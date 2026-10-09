/**
 * Nine Apps - Reusable Modular UI Components
 * Architecture Clean Code following Apple Human Interface Guidelines (HIG)
 * and SonarQube Maintainability Standards.
 */
(function (window, document) {
  'use strict';

  var NineComponents = {};

  /**
   * Generates a unified Apple HIG Status Pill.
   * Eliminates disparate custom badge styles (Anti-AI Slop).
   * @param {'online'|'syncing'|'offline'} status - Device connection state
   * @param {string} label - Display badge label
   * @returns {string} HTML string for status badge
   */
  NineComponents.renderStatusBadge = function (status, label) {
    var dotColor = 'bg-emerald-500';
    var pulse = '';
    var textClass = 'text-primary-950';

    if (status === 'syncing') {
      dotColor = 'bg-amber-500';
      pulse = 'animate-pulse';
    } else if (status === 'offline') {
      dotColor = 'bg-neutral-400';
      textClass = 'text-neutral-500';
    }

    return (
      '<span class="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full bg-neutral-100 border border-neutral-200/80 ' +
      textClass +
      ' font-micro text-[10px] font-bold uppercase tracking-wider shrink-0">' +
      '<span class="w-2 h-2 rounded-full ' +
      dotColor +
      ' ' +
      pulse +
      '"></span>' +
      (label || (status === 'online' ? 'Terhubung' : status === 'syncing' ? 'Sinkronisasi' : 'Terputus')) +
      '</span>'
    );
  };

  /**
   * Generates a reusable Telemetry Metric card cell.
   * @param {string} title - Uppercase metric title
   * @param {string} value - Main telemetric data
   * @param {string} [sub] - Optional secondary note
   * @returns {string} HTML string
   */
  NineComponents.renderTelemetryCell = function (title, value, sub) {
    return (
      '<div class="flex flex-col items-center justify-center p-2 rounded-xl bg-neutral-50 border border-neutral-100 text-center">' +
      '<span class="font-bold text-[10px] text-neutral-400 uppercase tracking-wider block">' + title + '</span>' +
      '<span class="font-bold text-xs text-primary-950 mt-0.5 block">' + value + '</span>' +
      (sub ? '<span class="font-micro text-[9px] text-neutral-400 block mt-0.5">' + sub + '</span>' : '') +
      '</div>'
    );
  };

  /**
   * Global Vehicles state repository for multi-vehicle garage switcher.
   */
  NineComponents.vehicles = [
    { id: 'v1', name: 'Yamaha NMAX 155', type: 'Motor', plate: 'B 1234 XYZ', active: true, accessories: 3 },
    { id: 'v2', name: 'Toyota Fortuner GR', type: 'Mobil', plate: 'B 9876 ABC', active: false, accessories: 2 },
    { id: 'v3', name: 'Honda PCX 160', type: 'Motor', plate: 'B 5544 KMN', active: false, accessories: 1 }
  ];

  /**
   * Opens the reusable Vehicle Switcher Bottom Sheet.
   */
  NineComponents.openVehicleSheet = function (onSelectCallback) {
    var sheet = document.getElementById('nine-vehicle-sheet');
    if (!sheet) {
      var html =
        '<div id="nine-vehicle-sheet" class="fixed inset-0 z-[80] bg-black/40 backdrop-blur-xs flex items-end justify-center">' +
        '<div class="w-full max-w-md bg-white rounded-t-3xl p-5 pb-8 shadow-2xl translate-y-full transition-transform duration-300" id="nine-vehicle-body">' +
        '<div data-sheet-handle class="ios-sheet-handle"></div>' +
        '<div class="flex items-center justify-between mb-1">' +
        '<h3 class="font-headline text-lg font-bold text-primary-950">Pilih Kendaraan Garasi</h3>' +
        '<button type="button" onclick="window.nineComponents.closeVehicleSheet()" class="text-xs font-bold text-neutral-400 hover:text-neutral-900">Tutup</button>' +
        '</div>' +
        '<p class="text-xs text-neutral-500 mb-4">Ganti unit aktif untuk melihat data telemetri & aksesori terpasang</p>' +
        '<div class="space-y-2.5" id="nine-vehicle-list"></div>' +
        '</div></div>';
      document.body.insertAdjacentHTML('beforeend', html);
      sheet = document.getElementById('nine-vehicle-sheet');
      sheet.addEventListener('click', function (e) {
        if (e.target === sheet) NineComponents.closeVehicleSheet();
      });
    }

    var list = document.getElementById('nine-vehicle-list');
    if (list) {
      list.innerHTML = NineComponents.vehicles.map(function (v) {
        var isCur = v.active;
        var icon = v.type === 'Mobil' ? 'ph-car' : 'ph-motorcycle';
        return (
          '<button type="button" onclick="window.nineComponents.selectVehicle(\'' + v.id + '\')" class="w-full p-3.5 rounded-2xl border ' +
          (isCur ? 'border-primary-950 bg-neutral-50' : 'border-neutral-200 bg-white hover:bg-neutral-50/50') +
          ' flex items-center justify-between text-left ios-press transition-all">' +
          '<div class="flex items-center gap-3 min-w-0">' +
          '<div class="w-10 h-10 rounded-xl bg-neutral-100 flex items-center justify-center text-primary-950 shrink-0">' +
          '<i class="ph-bold ' + icon + ' text-xl"></i></div>' +
          '<div class="min-w-0">' +
          '<div class="flex items-center gap-1.5">' +
          '<span class="font-bold text-xs text-primary-950 truncate">' + v.name + '</span>' +
          '<span class="px-1.5 py-0.5 rounded bg-neutral-100 text-[9px] font-bold text-neutral-600 uppercase font-mono">' + v.type + '</span>' +
          '</div>' +
          '<span class="text-[11px] text-neutral-500 font-mono block mt-0.5">' + v.plate + ' · ' + v.accessories + ' Aksesori</span>' +
          '</div></div>' +
          (isCur
            ? '<i class="ph-fill ph-check-circle text-primary-950 text-xl shrink-0"></i>'
            : '<span class="w-5 h-5 rounded-full border border-neutral-300 shrink-0"></span>') +
          '</button>'
        );
      }).join('');
    }

    NineComponents._onSelectVehicle = onSelectCallback;
    sheet.classList.remove('hidden');
    requestAnimationFrame(function () {
      var body = document.getElementById('nine-vehicle-body');
      if (body) body.classList.remove('translate-y-full');
    });
  };

  /**
   * Closes vehicle bottom sheet.
   */
  NineComponents.closeVehicleSheet = function () {
    var b = document.getElementById('nine-vehicle-body');
    var s = document.getElementById('nine-vehicle-sheet');
    if (b) b.classList.add('translate-y-full');
    setTimeout(function () {
      if (s) s.classList.add('hidden');
    }, 280);
  };

  /**
   * Selects an active vehicle.
   */
  NineComponents.selectVehicle = function (id) {
    NineComponents.vehicles.forEach(function (v) {
      v.active = v.id === id;
    });
    var selected = NineComponents.vehicles.find(function (v) { return v.id === id; });
    NineComponents.closeVehicleSheet();
    if (window.nineToast && selected) {
      window.nineToast('Kendaraan aktif: ' + selected.name, 'motorcycle');
    }
    if (typeof NineComponents._onSelectVehicle === 'function') {
      NineComponents._onSelectVehicle(selected);
    }
  };

  /**
   * Generates interactive Apple HIG 3-Step Booking Stepper HTML.
   * Aligned with STYLE_GUIDE_mall.md and Apple HIG.
   */
  NineComponents.bookingStepItems = [
    { title: "Layanan & Unit", icon: "ph-wrench" },
    { title: "Jadwal & Pit", icon: "ph-calendar" },
    { title: "Konfirmasi", icon: "ph-check-circle" }
  ];

  NineComponents.renderBookingStepper = function (currentStep, onStepClickFnName, customSteps) {
    var fnName = onStepClickFnName || "goToStep";
    var steps = customSteps || NineComponents.bookingStepItems;
    return steps.map(function (item, idx) {
      var stepNum = idx + 1;
      var isActive = stepNum === currentStep;
      var isPassed = stepNum < currentStep;

      var circleClass = isActive
        ? "bg-accent-600 text-white ring-4 ring-accent-600/20 shadow-xs"
        : (isPassed
            ? "bg-accent-600 text-white cursor-pointer hover:opacity-90"
            : "bg-white text-neutral-400 border border-neutral-200 cursor-not-allowed");

      var iconContent = isPassed
        ? '<i class="ph-bold ph-check text-xs"></i>'
        : '<span class="' + (isActive ? 'font-bold' : 'font-medium') + ' text-xs font-mono">' + stepNum + '</span>';

      var titleClass = isActive
        ? "text-accent-700 font-bold"
        : (isPassed ? "text-primary-950 font-semibold" : "text-neutral-400 font-normal");

      var connectorClass = isPassed ? "bg-accent-600" : "bg-neutral-200";
      var clickAttr = (isPassed || isActive) ? ' onclick="' + fnName + '(' + stepNum + ')"' : '';

      return (
        '<div class="flex-1 flex flex-col items-center relative text-center group cursor-pointer"' + clickAttr + '>' +
        (idx < steps.length - 1
          ? '<div class="absolute top-4 left-1/2 w-full h-[2px] -translate-y-1/2 -z-0 ' + connectorClass + '"></div>'
          : '') +
        '<div class="relative z-10 w-8 h-8 rounded-full flex items-center justify-center transition-all duration-200 ' + circleClass + '">' +
        iconContent +
        '</div>' +
        '<span class="mt-1.5 text-[10px] uppercase font-bold tracking-wider leading-tight block truncate max-w-[80px] transition-colors ' + titleClass + '">' + item.title + '</span>' +
        '</div>'
      );
    }).join("");
  };

  /**
   * Helper to render standardized Apple HIG Primary and Secondary buttons.
   */
  NineComponents.renderButton = function (opts) {
    var variant = opts.variant || 'primary';
    var cls = variant === 'primary' ? 'btn-primary' : (variant === 'outline' ? 'btn-outline' : (variant === 'danger' ? 'btn-danger' : 'btn-secondary'));
    var extraClass = opts.class ? ' ' + opts.class : '';
    var iconHtml = opts.icon ? '<i class="ph-bold ph-' + opts.icon + ' text-base"></i>' : '';
    var onclickAttr = opts.onclick ? ' onclick="' + opts.onclick + '"' : '';
    var idAttr = opts.id ? ' id="' + opts.id + '"' : '';
    var typeAttr = ' type="' + (opts.type || 'button') + '"';

    return (
      '<button' + typeAttr + idAttr + onclickAttr + ' class="' + cls + extraClass + '">' +
      iconHtml +
      '<span>' + (opts.text || '') + '</span>' +
      '</button>'
    );
  };

  /**
   * Helper to render Apple HIG Inset Grouped list row.
   */
  NineComponents.renderListRow = function (opts) {
    var tag = opts.href ? 'a' : 'div';
    var hrefAttr = opts.href ? ' href="' + opts.href + '"' : '';
    var onclickAttr = opts.onclick ? ' onclick="' + opts.onclick + '"' : '';
    var iconClass = opts.iconClass || 'ph-bold';
    
    return (
      '<' + tag + hrefAttr + onclickAttr + ' class="ios-list-row">' +
      '<div class="flex items-center gap-3 min-w-0">' +
      (opts.icon ? '<div class="ios-list-icon"><i class="' + iconClass + ' ph-' + opts.icon + ' text-lg"></i></div>' : '') +
      '<div class="min-w-0">' +
      '<span class="font-body-semibold text-caption text-primary-950 block truncate font-bold">' + opts.title + '</span>' +
      (opts.subtitle ? '<span class="font-caption text-caption text-neutral-500 block truncate mt-0.5">' + opts.subtitle + '</span>' : '') +
      '</div></div>' +
      '<div class="flex items-center gap-2 shrink-0">' +
      (opts.badge ? '<span class="px-2 py-0.5 rounded-full bg-neutral-100 border border-neutral-200/80 text-primary-950 font-micro text-micro font-bold uppercase tracking-wider">' + opts.badge + '</span>' : '') +
      (opts.rightText ? '<span class="text-xs text-neutral-400 font-medium">' + opts.rightText + '</span>' : '') +
      (opts.noChevron ? '' : '<i class="ph-bold ph-caret-right text-neutral-400 text-sm"></i>') +
      '</div></' + tag + '>'
    );
  };

  /**
   * Scarcity metric helper for promo bundling items.
   * Directly mirrors D:\\Frontend-Mall\\app\\components\\home\\PromoPackages.vue
   */
  NineComponents.getScarcityDetails = function (quota, soldCount) {
    var q = quota || 100;
    var s = soldCount || 0;
    var remaining = Math.max(0, q - s);
    var pct = Math.min(100, Math.round((s / q) * 100) || 0);
    return {
      quota: q,
      soldCount: s,
      remainingCount: remaining,
      percentage: pct
    };
  };

  window.nineComponents = NineComponents;
})(window, document);
