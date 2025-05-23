let currentIncomeCategoryForm = null;

document.addEventListener("turbo:load", () => {
  window.confirmIncomeCategoryDelete = (button) => {
    currentIncomeCategoryForm = button.closest("form");

    const select = currentIncomeCategoryForm.querySelector("select[name='category_id']");
    const selectedOption = select?.options[select.selectedIndex];

    if (!select || !select.value) {
      alert("カテゴリを選択してください");
      return;
    }

    const nameSpan = document.getElementById("income-category-name-to-delete");
    if (nameSpan) {
      nameSpan.textContent = selectedOption.text;
    }

    document.getElementById("incomeDeleteConfirmModal").style.display = "flex";
  };

  window.closeIncomeCategoryDeleteModal = () => {
    document.getElementById("incomeDeleteConfirmModal").style.display = "none";
    currentIncomeCategoryForm = null;
  };

  window.submitIncomeCategoryDeleteForm = () => {
    if (currentIncomeCategoryForm) {
      currentIncomeCategoryForm.submit();
    }
  };
});
