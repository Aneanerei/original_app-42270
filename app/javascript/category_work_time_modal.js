document.addEventListener("turbo:load", () => {
  const openBtn = document.getElementById("show-worktime-category-form");
  const modal = document.getElementById("worktime-category-modal");
  const closeBtn = document.getElementById("close-worktime-category-modal");

  const addForm = document.getElementById("worktime-add-form");
  const editForm = document.getElementById("worktime-edit-form");
  const deleteForm = document.getElementById("worktime-delete-form");

  const btnAdd = document.getElementById("show-worktime-add-form");
  const btnEdit = document.getElementById("show-worktime-edit-form");
  const btnDelete = document.getElementById("show-worktime-delete-form");

  function showOnly(target) {
    [addForm, editForm, deleteForm].forEach(f => {
      if (f) f.style.display = "none";
    });
    if (target) target.style.display = "block";
  }

  if (openBtn && modal) {
    openBtn.addEventListener("click", () => {
      modal.style.display = "flex"; // 表示
      showOnly(addForm); // 最初は追加フォームを表示
    });
  }

  if (closeBtn && modal) {
    closeBtn.addEventListener("click", () => {
      modal.style.display = "none"; // 非表示
    });
  }

  if (btnAdd) btnAdd.addEventListener("click", () => showOnly(addForm));
  if (btnEdit) btnEdit.addEventListener("click", () => showOnly(editForm));
  if (btnDelete) btnDelete.addEventListener("click", () => showOnly(deleteForm));
});
