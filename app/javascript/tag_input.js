document.addEventListener("turbo:load", () => {
  const container = document.getElementById("tagged-images");
  const template = document.getElementById("tagged-image-template");
  const addButton = document.getElementById("add-tagged-image");
  const dateInput = document.getElementById("expense_date");
  const categorySelect = document.getElementById("expense_category_expense_id");

  if (!container || !template) return;

  let index = container.querySelectorAll(".tagged-image-group").length;
  const max = 5;
  const maxTagLength = 20;
  const maxTagCount = 10;

 const normalizeTag = (tag) =>
  tag.trim()
    .replace(/[Ａ-Ｚａ-ｚ０-９]/g, s =>
      String.fromCharCode(s.charCodeAt(0) - 0xFEE0)
    );

  const getTags = (wrapper) =>
    Array.from(wrapper.querySelectorAll(".tag-badge")).map(el =>
      el.textContent.replace("×", "").trim()
    );

  function syncTagsToHiddenInput(wrapper) {
    const tags = getTags(wrapper);
    const hiddenInput = wrapper.querySelector(".hidden-tag-input");
    const removedInput = wrapper.querySelector(".removed-auto-tags-input");
    const removed = wrapper.dataset.removedAutoTags || "";

    if (hiddenInput) hiddenInput.value = tags.join(",");
    if (removedInput) removedInput.value = removed;
  }

  function addTag(wrapper, tag, isAuto = false) {
    const tagsContainer = wrapper.querySelector(".tags");
    tag = normalizeTag(tag);
    if (!tag || tag.length > maxTagLength) return;

    const existing = getTags(wrapper);
    if (existing.includes(tag)) {
      const found = [...tagsContainer.children].find(el => el.textContent.includes(tag));
      if (found) {
        found.classList.add("duplicate-tag");
        setTimeout(() => found.classList.remove("duplicate-tag"), 1200);
      }
      return;
    }

    if (existing.length >= maxTagCount) return;
    const removed = (wrapper.dataset.removedAutoTags || "").split(",");
    if (isAuto && removed.includes(tag)) return;

    const span = document.createElement("span");
    span.className = "tag-badge" + (isAuto ? " auto-tag" : "");
    if (isAuto) span.dataset.auto = "true";
    span.innerHTML = `${tag}<button type="button" class="remove-tag" data-tag="${tag}">×</button>`;
    tagsContainer.appendChild(span);

    syncTagsToHiddenInput(wrapper);
  }

  function applyAutoTags(group) {
    const formMode = document.getElementById("expense-form")?.dataset.mode;
    if (formMode === "edit") return;

    const wrapper = group.querySelector(".tag-input-wrapper");
    if (!wrapper) return;

    const removed = (wrapper.dataset.removedAutoTags || "").split(",");
    wrapper.querySelectorAll(".tag-badge[data-auto='true']").forEach(el => el.remove());

    const isNew = group.dataset.isNew === "true";
    const fileInput = group.querySelector('input[type="file"]');
    const hasFile = fileInput?.files?.length > 0;

    if (!isNew || !hasFile) return;

    const date = dateInput?.value ? new Date(dateInput.value) : new Date();
    const monthTag = `${date.getMonth() + 1}月`;

    const categoryOption = categorySelect?.selectedOptions[0];
    const categoryTag = categoryOption?.value ? categoryOption.textContent : "";

    [monthTag, categoryTag].forEach(tag => {
      if (tag && !removed.includes(tag)) {
        addTag(wrapper, tag, true);
      }
    });

    syncTagsToHiddenInput(wrapper);
  }

  function initTagInput(wrapper) {
    const input = wrapper.querySelector(".tag-input");
    if (input.dataset.initialized) return;
    input.dataset.initialized = "true";

    input.addEventListener("keydown", (e) => {
      if (["Enter", ",", " "].includes(e.key)) {
        e.preventDefault();
        const raw = input.value;
        const tag = normalizeTag(raw);
        addTag(wrapper, tag);
        input.value = "";
      }
    });

    wrapper.addEventListener("click", (e) => {
      if (e.target.classList.contains("remove-tag")) {
        const tagEl = e.target.closest(".tag-badge");
        const tag = e.target.dataset.tag;
        const isAuto = tagEl?.dataset.auto === "true";

        if (isAuto && tag) {
          const removed = wrapper.dataset.removedAutoTags?.split(",") || [];
          if (!removed.includes(tag)) {
            removed.push(tag);
            wrapper.dataset.removedAutoTags = removed.join(",");
          }
        }

        tagEl?.remove();
        syncTagsToHiddenInput(wrapper);
      }
    });
  }
function initImagePreview(input, previewId, group) {
  const preview = document.getElementById(previewId);
  const wrapper = group.querySelector(".tag-input-wrapper");
  const filenameEl = group.querySelector(`[data-filename-target="${previewId}"]`);

  if (!input || !preview || !wrapper) return;

  input.addEventListener("change", () => {
    const file = input.files[0];
    if (file) {
      // プレビュー画像
      preview.innerHTML = "";
      const img = document.createElement("img");
      img.src = URL.createObjectURL(file);
      img.className = "preview-image";
      preview.appendChild(img);

      // ファイル名表示
      if (filenameEl) {
        filenameEl.textContent = file.name;
      }

      group.setAttribute("data-has-image", "true");
      initTagInput(wrapper);
      applyAutoTags(group);
    } else {
      group.removeAttribute("data-has-image");
      preview.innerHTML = "";
      if (filenameEl) {
        filenameEl.textContent = "";
      }
      wrapper.querySelector(".tags").innerHTML = "";
      wrapper.querySelector(".hidden-tag-input").value = "";
    }
  });
}


  function handleDelete(e) {
    const group = e.target.closest(".tagged-image-group");
    const destroyInput = group.querySelector("input.destroy-flag");

    if (!group || !destroyInput) return;

    destroyInput.value = "1";
    const preview = group.querySelector(".image-preview");
    if (preview) preview.innerHTML = "";

    const wrapper = group.querySelector(".tag-input-wrapper");
    if (wrapper) {
      wrapper.querySelector(".tags").innerHTML = "";
      wrapper.querySelector(".hidden-tag-input").value = "";
      wrapper.querySelector(".tag-input").value = "";
    }

    group.style.display = "none";
  }

  function attachDeleteHandlers() {
    container.querySelectorAll(".delete-image-button").forEach(btn => {
      btn.removeEventListener("click", handleDelete);
      btn.addEventListener("click", handleDelete);
    });
  }

  function initializeExistingGroups() {
    container.querySelectorAll(".tagged-image-group").forEach(group => {
      const wrapper = group.querySelector(".tag-input-wrapper");
      const input = group.querySelector("input[type='file']");
      const previewId = group.querySelector(".image-preview")?.id;

      if (input && previewId) initImagePreview(input, previewId, group);
      if (wrapper) {
        initTagInput(wrapper);
        syncTagsToHiddenInput(wrapper);
      }
    });
  }

  function addNewField() {
    if (index >= max) return;

    const html = template.innerHTML.replace(/NEW_INDEX/g, index);
    const temp = document.createElement("div");
    temp.innerHTML = html;
    const group = temp.firstElementChild;
    group.dataset.isNew = "true";
    group.dataset.group = index;

    container.appendChild(group);

    const input = group.querySelector("input[type='file']");
    const previewId = group.querySelector(".image-preview")?.id;

    if (input && previewId) {
      initImagePreview(input, previewId, group);

      if (input.files.length > 0) {
        input.dispatchEvent(new Event("change"));
      }
    }

    const wrapper = group.querySelector(".tag-input-wrapper");
    if (wrapper) initTagInput(wrapper);

    attachDeleteHandlers();
    index++;
  }

  function updateAllAutoTags() {
    container.querySelectorAll(".tagged-image-group").forEach(applyAutoTags);
  }

  initializeExistingGroups();
  attachDeleteHandlers();
  addButton?.addEventListener("click", addNewField);
  categorySelect?.addEventListener("change", updateAllAutoTags);
  dateInput?.addEventListener("change", updateAllAutoTags);
});
