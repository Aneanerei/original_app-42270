document.addEventListener("turbo:load", () => {
  const modal = document.getElementById("income-category-modal");
  const openBtn = document.getElementById("show-category-form");
  const closeBtn = document.getElementById("close-income-category-modal");

  const addForm = document.getElementById("income-add-form");
  const editForm = document.getElementById("income-edit-form");
  const deleteForm = document.getElementById("income-delete-form");

  const btnAdd = document.getElementById("show-income-add-form");
  const btnEdit = document.getElementById("show-income-edit-form");
  const btnDelete = document.getElementById("show-income-delete-form");

  function showOnly(target) {
    [addForm, editForm, deleteForm].forEach(form => {
      if (form) form.style.display = "none";
    });
    if (target) target.style.display = "block";
  }

  if (openBtn && modal) {
    openBtn.addEventListener("click", () => {
      modal.style.display = "flex"; // モーダルを表示（中央配置）
      showOnly(addForm); // デフォルトで追加フォームを表示
    });
  }

  if (closeBtn && modal) {
    closeBtn.addEventListener("click", () => {
      modal.style.display = "none"; // モーダルを閉じる
    });
  }

  if (btnAdd) btnAdd.addEventListener("click", () => showOnly(addForm));
  if (btnEdit) btnEdit.addEventListener("click", () => showOnly(editForm));
  if (btnDelete) btnDelete.addEventListener("click", () => showOnly(deleteForm));
});
