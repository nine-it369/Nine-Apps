// Shared app shell - Apple Human Interface Guidelines (HIG) + Nine Mall Design System
(function () {
  var TABS = [
    { key: "beranda", href: "home.html", icon: "house", label: "Beranda" },
    { key: "aksesori", href: "accecories.html", icon: "cpu", label: "Aksesori" },
    { key: "mall", href: "mall.html", icon: "storefront", label: "Mall" },
    { key: "booking", href: "booking.html", icon: "calendar-dots", label: "Booking" },
    { key: "akun", href: "profile.html", icon: "user-circle", label: "Akun" }
  ];

  var current = document.body.dataset.tab || "";
  var body = document.body;

  function cartCount() {
    var n = parseInt(localStorage.getItem("nine_cart") || "2", 10);
    return isNaN(n) || n < 0 ? 0 : n;
  }

  var badge = cartCount();
  var ICON = "text-[21px]";

  var isTransparentHeader = body.dataset.header === "transparent";
  var headerBgClass = isTransparentHeader
    ? "bg-transparent border-transparent shadow-none"
    : "bg-white/75 backdrop-blur-2xl border-b border-neutral-200/50 shadow-2xs";

  var leading;
  if (body.dataset.search === "off") {
    leading =
      '<button type="button" onclick="if(window.history.length>1){window.history.back();}else{location.href=\'home.html\';}" aria-label="Kembali" class="w-10 h-10 -ml-1 shrink-0 flex items-center justify-center text-primary-950 rounded-full active:opacity-60 transition-opacity"><i class="ph-bold ph-caret-left text-[20px]"></i></button>' +
      '<h1 class="flex-1 text-center font-headline text-[16px] font-bold text-primary-950 tracking-tight truncate px-2">' + (body.dataset.title || "Nine Autogarage") + '</h1>' +
      '<span class="w-10 shrink-0" aria-hidden="true"></span>';
  } else if (body.dataset.search === "title") {
    leading = '<h1 class="flex-1 font-headline text-[17px] font-bold text-primary-950 tracking-tight truncate">' + (body.dataset.title || "Nine Autogarage") + "</h1>";
  } else {
    leading =
      '<a href="catalog.html" aria-label="Cari aksesori di Mall" class="flex-1 min-w-0 flex items-center gap-2 h-10 px-3.5 rounded-2xl bg-white/85 hover:bg-white text-primary-950 border border-neutral-200/80 shadow-2xs backdrop-blur-md transition-all active:opacity-75">' +
      '<i class="ph-bold ph-magnifying-glass text-[17px] text-neutral-500 shrink-0"></i>' +
      '<span class="font-body text-xs text-neutral-500 truncate">' + (body.dataset.search || "Cari aksesori di Mall…") + "</span></a>";
  }

  var header =
    '<header class="fixed top-0 inset-x-0 z-50 pt-safe transition-all duration-300 ' + headerBgClass + '">' +
    '<div class="max-w-md mx-auto h-13 px-4 flex items-center gap-2">' + leading;

  if (body.dataset.search !== "off") {
    header +=
      '<div class="flex items-center gap-1 shrink-0 ml-auto">' +
      '<button type="button" onclick="window.nineOpenHelp()" aria-label="Bantuan & CS" class="tap-44 w-10 h-10 flex items-center justify-center rounded-full text-primary-950/80 hover:text-primary-950 active:opacity-60 transition-opacity"><i class="ph-bold ph-headset ' + ICON + '"></i></button>' +
      '<a href="keranjang.html" aria-label="Keranjang Belanja" class="tap-44 relative w-10 h-10 flex items-center justify-center rounded-full text-primary-950/80 hover:text-primary-950 active:opacity-60 transition-opacity"><i class="ph-bold ph-shopping-bag ' + ICON + '"></i>' +
      '<span data-cart-badge class="absolute top-1 right-1 min-w-[17px] h-[17px] px-1 rounded-full bg-accent-500 text-white font-micro text-[10px] font-bold flex items-center justify-center shadow-xs leading-none">' + badge + "</span></a>" +
      "</div>";
  }

  header += "</div></header>";

  var nav =
    '<nav class="fixed bottom-0 inset-x-0 z-50 w-full bg-white/95 backdrop-blur-2xl border-t border-neutral-200/80 shadow-[0_-2px_12px_rgba(0,0,0,0.03)] pb-safe">' +
    '<div class="max-w-md mx-auto h-[60px] px-2 flex items-center justify-around">' +
    TABS.map(function (t) {
      var on = t.key === current;
      var idleClass = "flex flex-col items-center justify-center gap-0.5 flex-1 min-h-[48px] text-neutral-400 hover:text-neutral-600 active:scale-95 transition-all";
      var onClass = "flex flex-col items-center justify-center gap-0.5 flex-1 min-h-[48px] text-accent-600 font-bold active:scale-95 transition-all";
      return '<a href="' + t.href + '" data-tab="' + t.key + '" class="' + (on ? onClass : idleClass) + '">' +
        '<i class="' + (on ? "ph-fill text-accent-600 text-[23px] scale-105" : "ph text-neutral-400 text-[22px]") + ' ph-' + t.icon + ' transition-transform"></i>' +
        '<span class="text-[10.5px] leading-tight tracking-tight ' + (on ? "text-accent-600 font-bold" : "text-neutral-400 font-medium") + '">' + t.label + "</span>" +
        '</a>';
    }).join("") +
    "</div></nav>";

  var bare = body.dataset.shell === "bare";
  var noNav = body.dataset.shell === "detail" || body.dataset.shell === "nonav" || body.dataset.notab === "true";
  if (!bare) {
    body.insertAdjacentHTML("afterbegin", header);
    if (!noNav) {
      body.insertAdjacentHTML("beforeend", nav);
    }
  }

  // Apple HIG Global Toast (Dynamic Island style notification)
  window.nineToast = function (msg, icon) {
    var t = document.getElementById("nine-toast");
    if (!t) {
      t = document.createElement("div");
      t.id = "nine-toast";
      t.setAttribute("role", "status");
      t.className =
        "fixed bottom-20 left-1/2 -translate-x-1/2 z-[70] max-w-[90%] px-4 py-2.5 rounded-2xl bg-primary-950/95 text-white backdrop-blur-md shadow-2xl border border-white/10 flex items-center gap-2.5 text-xs font-semibold opacity-0 pointer-events-none translate-y-3 transition-all duration-200";
      body.appendChild(t);
    }
    t.innerHTML = '<i class="ph-bold ph-' + (icon || "check-circle") + ' text-[17px] text-accent-500 shrink-0"></i><span class="truncate">' + msg + "</span>";
    requestAnimationFrame(function () {
      t.classList.remove("opacity-0", "translate-y-3", "pointer-events-none");
    });
    clearTimeout(window.__nineToast);
    window.__nineToast = setTimeout(function () {
      t.classList.add("opacity-0", "translate-y-3", "pointer-events-none");
    }, 2200);
  };

  // Support / Help Bottom Sheet
  window.nineOpenHelp = function () {
    var sheet = document.getElementById("nine-help-sheet");
    if (!sheet) {
      var html =
        '<div id="nine-help-sheet" class="fixed inset-0 z-[80] bg-black/40 backdrop-blur-xs flex items-end justify-center">' +
        '<div class="w-full max-w-md bg-white rounded-t-3xl p-5 pb-8 shadow-2xl translate-y-full transition-transform duration-300" id="nine-help-body">' +
        '<div data-sheet-handle class="ios-sheet-handle"></div>' +
        '<h3 class="font-headline text-lg font-bold text-primary-950 text-center">Bantuan & Dukungan Nine</h3>' +
        '<p class="text-xs text-secondary text-center mt-1 mb-5">Pusat layanan pelanggan & pelacakan pesanan resmi</p>' +
        '<div class="space-y-2.5">' +
        '<a href="https://wa.me/6283173271177" target="_blank" class="w-full p-3.5 rounded-xl bg-accent-50 border border-accent-200 flex items-center gap-3 ios-press">' +
        '<div class="w-10 h-10 rounded-xl bg-accent-500 text-white flex items-center justify-center shrink-0"><i class="ph-bold ph-whatsapp-logo text-[22px]"></i></div>' +
        '<div class="flex-1 min-w-0"><span class="font-bold text-sm text-primary-950 block">Chat CS WhatsApp Nine</span><span class="text-xs text-accent-700">Respon cepat · Konsultasi teknis & komplain</span></div>' +
        '<i class="ph-bold ph-caret-right text-accent-600 text-sm"></i></a>' +
        '<a href="track.html" class="w-full p-3.5 rounded-xl bg-neutral-50 border border-neutral-200 flex items-center gap-3 ios-press">' +
        '<div class="w-10 h-10 rounded-xl bg-info text-white flex items-center justify-center shrink-0"><i class="ph-bold ph-truck text-[22px]"></i></div>' +
        '<div class="flex-1 min-w-0"><span class="font-bold text-sm text-primary-950 block">Lacak Status Pesanan / Resi</span><span class="text-xs text-secondary">Cek kurir J&T Express secara langsung</span></div>' +
        '<i class="ph-bold ph-caret-right text-neutral-400 text-sm"></i></a>' +
        '<button type="button" onclick="window.nineToast(\'Panduan dan FAQ tersedia di menu Akun\', \'info\')" class="w-full p-3.5 rounded-xl bg-neutral-50 border border-neutral-200 flex items-center gap-3 text-left ios-press">' +
        '<div class="w-10 h-10 rounded-xl bg-primary-800 text-white flex items-center justify-center shrink-0"><i class="ph-bold ph-question text-[22px]"></i></div>' +
        '<div class="flex-1 min-w-0"><span class="font-bold text-sm text-primary-950 block">FAQ & Garansi Resmi</span><span class="text-xs text-secondary">Ketentuan klaim garansi 12 - 24 bulan</span></div>' +
        '<i class="ph-bold ph-caret-right text-neutral-400 text-sm"></i></button>' +
        '</div>' +
        '<button type="button" onclick="window.nineCloseHelp()" class="mt-4 w-full h-11 rounded-xl bg-neutral-100 text-primary-950 font-semibold text-sm active:opacity-70 transition-opacity">Tutup</button>' +
        '</div></div>';
      body.insertAdjacentHTML("beforeend", html);
      sheet = document.getElementById("nine-help-sheet");
      sheet.addEventListener("click", function (e) {
        if (e.target === sheet) window.nineCloseHelp();
      });
    }
    sheet.classList.remove("hidden");
    requestAnimationFrame(function () {
      var b = document.getElementById("nine-help-body");
      if (b) b.classList.remove("translate-y-full");
    });
  };

  window.nineCloseHelp = function () {
    var b = document.getElementById("nine-help-body");
    var sheet = document.getElementById("nine-help-sheet");
    if (b) b.classList.add("translate-y-full");
    setTimeout(function () {
      if (sheet) sheet.classList.add("hidden");
    }, 280);
  };

  // Sheet swipe-to-dismiss gesture handling
  function closeOverlay(overlay, panel) {
    panel.style.transform = "translateY(100%)";
    setTimeout(function () {
      overlay.classList.add("hidden");
      panel.style.transform = "";
      panel.style.transition = "";
    }, 280);
  }

  document.querySelectorAll("[data-sheet-handle]").forEach(function (handle) {
    var panel = handle.parentElement;
    var overlay = panel.closest(".fixed.inset-0");
    if (!panel || !overlay) return;
    var startY = null, dy = 0;
    handle.addEventListener("pointerdown", function (e) {
      startY = e.clientY; dy = 0;
      panel.style.transition = "none";
      if (handle.setPointerCapture) handle.setPointerCapture(e.pointerId);
    });
    handle.addEventListener("pointermove", function (e) {
      if (startY === null) return;
      dy = Math.max(0, e.clientY - startY);
      panel.style.transform = "translateY(" + dy + "px)";
    });
    function end() {
      if (startY === null) return;
      var shouldClose = dy > 80;
      panel.style.transition = "";
      panel.style.transform = "";
      startY = null;
      if (shouldClose) closeOverlay(overlay, panel);
    }
    handle.addEventListener("pointerup", end);
    handle.addEventListener("pointercancel", end);
  });

  document.addEventListener("keydown", function (e) {
    if (e.key !== "Escape") return;
    var open = Array.prototype.filter.call(
      document.querySelectorAll(".fixed.inset-0"),
      function (el) { return !el.classList.contains("hidden"); }
    );
    var top = open[open.length - 1];
    if (!top) return;
    var panel = top.querySelector("[data-sheet-handle]");
    if (panel) closeOverlay(top, panel.parentElement);
    else top.classList.add("hidden");
  });

  window.nineCartSet = function (n) {
    localStorage.setItem("nine_cart", String(n));
    document.querySelectorAll("[data-cart-badge]").forEach(function (b) {
      b.textContent = n;
    });
  };
})();