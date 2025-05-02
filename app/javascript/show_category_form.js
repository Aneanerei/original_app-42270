document.addEventListener("turbo:load", () => {
  const openBtn = document.getElementById("show-category-form");
  const modal = document.getElementById("modal-overlay");
  const closeBtn = document.getElementById("close-modal");

  if (openBtn && modal && closeBtn) {
    openBtn.addEventListener("click", () => {
      modal.style.display = "flex";
    });

    closeBtn.addEventListener("click", () => {
      modal.style.display = "none";
    });
  } else {
    console.warn("必要な要素が見つかりません");
  }
});
