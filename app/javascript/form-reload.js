document.addEventListener("turbo:submit-end", function (event) {
  if (!event.detail.success) {
    setTimeout(() => {
      window.location.reload();
    }, 2000); // 2秒後にリロード
  }
});