document.addEventListener("turbo:load", () => {
  document.querySelectorAll(".meter-bar").forEach((bar) => {
    const target = parseFloat(bar.dataset.percent);
    const max = parseFloat(bar.dataset.max || "100");
    if (isNaN(target) || isNaN(max)) return;

    const label = bar.closest(".meter-outer")?.querySelector(".meter-label");
    let current = 0;

    const start = max > 200 ? 200 : max > 100 ? 100 : 0;
    const scaleWidth = 100;

    const interval = setInterval(() => {
      if (current > target) {
        clearInterval(interval);
        return;
      }

      const display = current > start ? current - start : 0;
      const width = (display / scaleWidth * 100).toFixed(2);
      bar.style.width = `${width}%`;

      if (label) label.textContent = `${Math.round(current)}%`;
      if (current > 100) bar.classList.add("over");

      current++;
    }, 10);
  });

  document.querySelectorAll(".meter-scale").forEach((scale) => {
    const max = parseInt(scale.dataset.max || "100", 10);
    scale.innerHTML = "";

    // スケールの開始点（0〜100、100〜200、200〜300）
    const start = max > 200 ? 200 : max > 100 ? 100 : 0;
    const scaleWidth = 100;

    for (let i = 0; i <= scaleWidth; i += 25) {
      const val = start + i;
      const span = document.createElement("span");
      span.textContent = `${val}%`;

      // 精密な位置に配置
      const left = (i / scaleWidth) * 100;
      span.style.position = "absolute";
      span.style.left = `${left}%`;
      span.style.transform = "translateX(-50%)";
      span.style.fontSize = "0.8em";
      span.style.color = "#666";

      scale.appendChild(span);
    }
  });
});
