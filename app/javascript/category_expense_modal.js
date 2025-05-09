document.addEventListener("turbo:load", () => {
  const expenseModal = document.getElementById("expense-category-modal");
  const openExpenseModalBtn = document.getElementById("show-expense-category-form");
  const closeExpenseModalBtn = document.getElementById("close-expense-category-modal");

  const expenseAddForm = document.getElementById("expense-add-form");
  const expenseEditForm = document.getElementById("expense-edit-form");
  const expenseDeleteForm = document.getElementById("expense-delete-form");

  const btnExpenseAdd = document.getElementById("show-expense-add-form");
  const btnExpenseEdit = document.getElementById("show-expense-edit-form");
  const btnExpenseDelete = document.getElementById("show-expense-delete-form");

  // モーダル存在チェック（他画面無効化）
  if (!expenseModal) return;

  // 表示フォーム切替
  function showOnlyExpenseForm(target) {
    [expenseAddForm, expenseEditForm, expenseDeleteForm].forEach(form => {
      if (form) form.style.display = "none";
    });
    if (target) target.style.display = "block";
  }

  // モーダル開閉
  openExpenseModalBtn?.addEventListener("click", () => {
    expenseModal.style.display = "flex";
    showOnlyExpenseForm(expenseAddForm); // 初期表示は追加フォーム
  });

  closeExpenseModalBtn?.addEventListener("click", () => {
    expenseModal.style.display = "none";
  });

  // 切替ボタン
  btnExpenseAdd?.addEventListener("click", () => showOnlyExpenseForm(expenseAddForm));
  btnExpenseEdit?.addEventListener("click", () => showOnlyExpenseForm(expenseEditForm));
  btnExpenseDelete?.addEventListener("click", () => showOnlyExpenseForm(expenseDeleteForm));

  // 削除確認モーダル制御
  let currentExpenseDeleteForm = null;

  window.confirmExpenseCategoryDelete = (button) => {
    currentExpenseDeleteForm = button.closest("form");

    const select = currentExpenseDeleteForm.querySelector("select[name='category_id']");
    const selectedOption = select?.options[select.selectedIndex];

    if (!select || !select.value) {
      alert("カテゴリを選択してください");
      return;
    }

    const nameSpan = document.getElementById("delete-expense-category-name");
    if (nameSpan && selectedOption) {
      nameSpan.textContent = selectedOption.text;
    }

    document.getElementById("customExpenseCategoryDeleteModal").style.display = "flex";
  };

  window.closeExpenseCategoryDeleteModal = () => {
    document.getElementById("customExpenseCategoryDeleteModal").style.display = "none";
    currentExpenseDeleteForm = null;
  };

  window.submitExpenseCategoryDeleteForm = () => {
    if (currentExpenseDeleteForm) {
      currentExpenseDeleteForm.submit();
    }
  };
});
