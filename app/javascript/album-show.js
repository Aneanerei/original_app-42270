document.addEventListener("turbo:load", () => {
  const modal = document.getElementById("album-detail-modal");
  if (!modal) return;

  const modalImage = document.getElementById("modal-image");
  const modalDate = document.getElementById("modal-date");
  const modalCategory = document.getElementById("modal-category");
  const modalTags = document.getElementById("modal-tags");
  const modalMemo = document.getElementById("modal-memo");
  const closeBtn = document.querySelector(".album-modal-close");

  // 各カードにクリックイベントを設定
  document.querySelectorAll(".album-card").forEach(card => {
    card.addEventListener("click", () => {
      modalImage.src = card.dataset.imageUrl;
      modalDate.textContent = card.dataset.date;
      modalCategory.textContent = card.dataset.category;
      modalTags.textContent = card.dataset.tags;
      modalMemo.textContent = card.dataset.memo;
      modal.style.display = "flex";
    });
  });

  // 閉じるボタン
  if (closeBtn) {
    closeBtn.addEventListener("click", () => {
      modal.style.display = "none";
    });
  }

  // 背景クリックで閉じる
  window.addEventListener("click", (e) => {
    if (e.target === modal) {
      modal.style.display = "none";
    }
  });
});
