document.addEventListener("turbo:load", () => {
  const addButton = document.getElementById("add-tagged-image");
  const container = document.getElementById("tagged-images");
  const templateElement = document.getElementById("tagged-image-template");
  const categorySelect = document.getElementById("expense_category_expense_id");
  const dateInput = document.getElementById("expense_date");

  if (!container || !templateElement) return;

  const templateHTML = templateElement.innerHTML;
  let index = container.querySelectorAll(".tagged-image-group").length;
  const max = 5;

  const handleImagePreview = (input, previewId) => {
    input.addEventListener("change", (e) => {
      const file = e.target.files[0];
      if (!file) return;

      const preview = document.getElementById(previewId);
      if (!preview) return;

      preview.innerHTML = "";
      const img = document.createElement("img");
      img.src = URL.createObjectURL(file);
      img.classList.add("preview-image");
      preview.appendChild(img);

      const group = input.closest(".tagged-image-group");
      updateTagInput(group);
    });
  };

  const updateTagInput = (group) => {
    const tagInput = group.querySelector('input[name*="[tag_list]"]');
    const fileInput = group.querySelector('input[type="file"]');
    const hasFile = fileInput?.files?.length > 0;

    if (!tagInput || !hasFile) return;

    const dateValue = dateInput?.value;
    let monthTag = "";
    if (dateValue) {
      const selectedDate = new Date(dateValue);
      monthTag = `${selectedDate.getMonth() + 1}月`;
    }

    const categoryTag = categorySelect?.options[categorySelect.selectedIndex]?.text || "";
    const tags = [monthTag, categoryTag].filter(Boolean).join(", ");
    tagInput.value = tags;
  };

  const handleDelete = (e) => {
    const group = e.target.closest(".tagged-image-group");
    const destroyInput = group.querySelector("input.destroy-flag");

    if (destroyInput) {
      destroyInput.value = "1";
      group.style.display = "none";
    } else {
      group.remove();
      index--;
    }
  };

  const attachDeleteHandlers = () => {
    container.querySelectorAll(".delete-image-button").forEach(button => {
      button.removeEventListener("click", handleDelete);
      button.addEventListener("click", handleDelete);
    });
  };

  const attachTagUpdater = () => {
    container.querySelectorAll(".tagged-image-group").forEach((group) => {
      const fileInput = group.querySelector('input[type="file"]');
      if (fileInput) {
        fileInput.removeEventListener("change", () => updateTagInput(group)); // 念のため
        fileInput.addEventListener("change", () => updateTagInput(group));
      }
    });
  };

  const addField = () => {
    if (index >= max) return;

    const replacedHTML = templateHTML.replace(/NEW_INDEX/g, index);
    const wrapper = document.createElement("div");
    wrapper.innerHTML = replacedHTML;
    const newGroup = wrapper.firstElementChild;

    const input = newGroup.querySelector('input[type="file"]');
    const previewId = newGroup.querySelector(".image-preview")?.id;

    if (input && previewId) {
      handleImagePreview(input, previewId);
    }

    container.appendChild(newGroup);
    attachDeleteHandlers();
    attachTagUpdater();
    index++;
  };

  // 初期画像のプレビュー＆タグ自動化
  container.querySelectorAll(".tagged-image-group").forEach((group) => {
    const input = group.querySelector('input[type="file"]');
    const previewId = input?.dataset.previewTarget;
    if (input && previewId) handleImagePreview(input, previewId);
  });

  attachDeleteHandlers();
  attachTagUpdater();

  addButton?.addEventListener("click", () => {
    addField();
  });

  // ✅ カテゴリ・日付変更時にはタグは更新しないように削除
  // categorySelect?.addEventListener("change", updateAllTagInputs);
  // dateInput?.addEventListener("change", updateAllTagInputs);
});
