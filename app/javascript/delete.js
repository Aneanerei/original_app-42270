let currentForm = null;

document.addEventListener("turbo:load", () => {
  window.confirmDelete = (button) => {
    currentForm = button.closest("form");
    document.getElementById("customDeleteModal").style.display = "flex";
  };

  window.closeDeleteModal = () => {
    document.getElementById("customDeleteModal").style.display = "none";
    currentForm = null;
  };

  window.submitDeleteForm = () => {
    if (currentForm) currentForm.submit();
  };
});

