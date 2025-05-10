document.addEventListener("turbo:load", () => {
  const addButton = document.getElementById("add-tagged-image");
  const container = document.getElementById("tagged-images");
  const templateElement = document.getElementById("tagged-image-template");
  const categorySelect = document.getElementById("expense_category_expense_id");
  const dateInput = document.getElementById("expense_date");

  if (!container || !templateElement) return;

  let index = container.querySelectorAll(".tagged-image-group").length;
  const max = 5;
  const templateHTML = templateElement.innerHTML;

  function initImagePreview(input, previewId, group) {
    input.addEventListener("change", () => {
      const file = input.files[0];
      if (!file) return;

      const preview = document.getElementById(previewId);
      if (preview) {
        preview.innerHTML = "";
        const img = document.createElement("img");
        img.src = URL.createObjectURL(file);
        img.classList.add("preview-image");
        preview.appendChild(img);
      }

      group?.setAttribute("data-has-image", "true");
      updateTagInput(group);
    });
  }

  function updateTagInput(group) {
    const tagInput = group.querySelector('input[name*="[tag_list]"]');
    const fileInput = group.querySelector('input[type="file"]');
    const hasImage = fileInput?.files?.length > 0 || group?.dataset.hasImage === "true";

    if (!tagInput || !hasImage) return;

    const selectedDate = dateInput?.value ? new Date(dateInput.value) : null;
    const monthTag = selectedDate ? `${selectedDate.getMonth() + 1}月` : "";
    const categoryTag = categorySelect?.options[categorySelect.selectedIndex]?.text || "";
    tagInput.value = [monthTag, categoryTag].filter(Boolean).join(", ");
  }

  function updateAllTagInputs() {
    container.querySelectorAll('.tagged-image-group[data-has-image="true"]').forEach(updateTagInput);
  }

  function handleDelete(e) {
    const group = e.target.closest(".tagged-image-group");
    const destroyInput = group.querySelector("input.destroy-flag");

    if (destroyInput) {
      destroyInput.value = "1";
      group.style.display = "none";
    } else {
      group.remove();
      index--;
    }
  }

  function attachDeleteHandlers() {
    container.querySelectorAll(".delete-image-button").forEach(button => {
      button.removeEventListener("click", handleDelete);
      button.addEventListener("click", handleDelete);
    });
  }

  function attachInitialPreviews() {
    container.querySelectorAll(".tagged-image-group").forEach(group => {
      const input = group.querySelector('input[type="file"]');
      const previewId = input?.dataset.previewTarget;
      if (input && previewId) initImagePreview(input, previewId, group);
    });
  }

  function addNewField() {
    if (index >= max) return;

    const newHTML = templateHTML.replace(/NEW_INDEX/g, index);
    const wrapper = document.createElement("div");
    wrapper.innerHTML = newHTML;
    const newGroup = wrapper.firstElementChild;

    const input = newGroup.querySelector('input[type="file"]');
    const previewId = newGroup.querySelector(".image-preview")?.id;

    if (input && previewId) {
      initImagePreview(input, previewId, newGroup);
    }

    container.appendChild(newGroup);
    attachDeleteHandlers();
    index++;
  }

  // 初期化処理
  attachInitialPreviews();
  attachDeleteHandlers();

  addButton?.addEventListener("click", addNewField);
  categorySelect?.addEventListener("change", updateAllTagInputs);
  dateInput?.addEventListener("change", updateAllTagInputs);
});
