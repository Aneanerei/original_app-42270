document.addEventListener("turbo:load", () => {
  document.querySelectorAll(".meter-bar").forEach((bar) => {
    const target = parseFloat(bar.dataset.percent);   // 実際の進捗率（例：166）
    const max = parseFloat(bar.dataset.max || "100"); // 表示スケールの上限（例：200）
    if (isNaN(target) || isNaN(max)) return;

    const label = bar.closest(".meter-outer")?.querySelector(".meter-label");
    let current = 0;

    const base = max > 100 ? max - 100 : 100;  // 100超のスケール表示用
    const start = max > 100 ? 100 : 0;         // スケールの開始点

    const interval = setInterval(() => {
      if (current > target) {
        clearInterval(interval);
        return;
      }

      // 「ゾーン内での相対的な幅」を描画する
      const displayProgress = current > start ? current - start : 0;
      const width = (displayProgress / base * 100).toFixed(2);
      bar.style.width = `${width}%`;

      if (label) label.textContent = `${Math.round(current)}%`;
      if (current > 100) bar.classList.add("over");

      current++;
    }, 10);
  });

  document.querySelectorAll(".meter-scale").forEach((scale) => {
    const max = parseInt(scale.dataset.max || "100", 10);
    scale.innerHTML = "";
    const labels = max > 100
      ? [100, 125, 150, 175, 200, 225, 250, 275, 300].filter(val => val <= max)
      : [0, 25, 50, 75, 100];
    labels.forEach(val => {
  const span = document.createElement("span");
  span.textContent = `${val}%`;
  const start = max > 100 ? max - 100 : 0;
  const scaleWidth = max > 100 ? 100 : max;
  const left = ((val - start) / scaleWidth) * 100;
  span.style.left = `${left}%`; // ← 位置を%指定で正確に
  scale.appendChild(span);
});
  });
});
