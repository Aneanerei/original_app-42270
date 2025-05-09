let currentExpenseCategoryForm = null;

document.addEventListener("turbo:load", () => {
  window.confirmExpenseCategoryDelete = (button) => {
    currentExpenseCategoryForm = button.closest("form");

    const select = currentExpenseCategoryForm.querySelector("select[name='category_id']");
    const selectedOption = select?.options[select.selectedIndex];

    // カテゴリが未選択なら警告
    if (!select || !select.value) {
      alert("カテゴリを選択してください");
      return;
    }

    // カテゴリ名をモーダルに表示
    const nameSpan = document.getElementById("delete-expense-category-name");
    if (nameSpan && selectedOption) {
      nameSpan.textContent = selectedOption.text;
    }

    // モーダルを表示
    document.getElementById("customExpenseCategoryDeleteModal").style.display = "flex";
  };

  window.closeExpenseCategoryDeleteModal = () => {
    document.getElementById("customExpenseCategoryDeleteModal").style.display = "none";
    currentExpenseCategoryForm = null;
  };

  window.submitExpenseCategoryDeleteForm = () => {
    if (currentExpenseCategoryForm) currentExpenseCategoryForm.submit();
  };
});
