document.addEventListener("turbo:load", () => {
  const modal = document.getElementById("income-category-modal");
  const openBtn = document.getElementById("show-income-category-form");
  const closeBtn = document.getElementById("close-income-category-modal");

  const addForm = document.getElementById("income-add-form");
  const editForm = document.getElementById("income-edit-form");
  const deleteForm = document.getElementById("income-delete-form");

  const btnAdd = document.getElementById("show-income-add-form");
  const btnEdit = document.getElementById("show-income-edit-form");
  const btnDelete = document.getElementById("show-income-delete-form");

  // モーダルが存在しないページでは動作させない
  if (!modal) return;

  // フォーム切り替え
  function showOnly(target) {
    [addForm, editForm, deleteForm].forEach(form => {
      if (form) form.style.display = "none";
    });
    if (target) target.style.display = "block";
  }

  if (openBtn) {
    openBtn.addEventListener("click", () => {
      modal.style.display = "flex";
      showOnly(addForm); // デフォルトは追加フォーム
    });
  }

  if (closeBtn) {
    closeBtn.addEventListener("click", () => {
      modal.style.display = "none";
    });
  }

  btnAdd?.addEventListener("click", () => showOnly(addForm));
  btnEdit?.addEventListener("click", () => showOnly(editForm));
  btnDelete?.addEventListener("click", () => showOnly(deleteForm));

  // 削除確認モーダル制御
  let currentIncomeDeleteForm = null;

  window.confirmIncomeCategoryDelete = (button) => {
    currentIncomeDeleteForm = button.closest("form");

    const select = currentIncomeDeleteForm.querySelector("select[name='category_id']");
    const selectedOption = select?.options[select.selectedIndex];

    if (!select || !select.value) {
      alert("カテゴリを選択してください");
      return;
    }

    const nameSpan = document.getElementById("income-category-name-to-delete");
    if (nameSpan && selectedOption) {
      nameSpan.textContent = selectedOption.text;
    }

    document.getElementById("incomeDeleteConfirmModal").style.display = "flex";
  };

  window.closeIncomeCategoryDeleteModal = () => {
    document.getElementById("incomeDeleteConfirmModal").style.display = "none";
    currentIncomeDeleteForm = null;
  };

  window.submitIncomeCategoryDeleteForm = () => {
    if (currentIncomeDeleteForm) {
      currentIncomeDeleteForm.submit();
    }
  };
});
