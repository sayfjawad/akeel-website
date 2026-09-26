// Interactie voor deze website — vanilla JavaScript, geen dependencies.
(function () {
  "use strict";

  /* ---------- Mobiel menu ---------- */
  const toggle = document.querySelector(".nav-toggle");
  const nav = document.getElementById("site-nav");

  function closeNav() {
    if (!nav || !toggle) return;
    nav.classList.remove("is-open");
    toggle.setAttribute("aria-expanded", "false");
  }

  if (toggle && nav) {
    toggle.addEventListener("click", () => {
      const open = nav.classList.toggle("is-open");
      toggle.setAttribute("aria-expanded", String(open));
    });
    nav.addEventListener("click", (event) => {
      if (event.target instanceof HTMLAnchorElement) closeNav();
    });
    document.addEventListener("keydown", (event) => {
      if (event.key === "Escape") closeNav();
    });
    window.addEventListener("resize", () => {
      if (window.innerWidth > 720) closeNav();
    });
  }

  /* ---------- Header krijgt een achtergrond zodra je scrolt ---------- */
  const header = document.querySelector(".site-header");
  function onScroll() {
    if (header) header.classList.toggle("is-scrolled", window.scrollY > 8);
  }
  onScroll();
  window.addEventListener("scroll", onScroll, { passive: true });

  /* ---------- Secties en kaarten rustig laten verschijnen ---------- */
  const revealItems = document.querySelectorAll(".section, .card, .project");
  const reduceMotion = window.matchMedia("(prefers-reduced-motion: reduce)").matches;

  if (reduceMotion || !("IntersectionObserver" in window)) {
    revealItems.forEach((el) => el.classList.add("is-visible"));
  } else {
    revealItems.forEach((el) => el.classList.add("reveal"));
    const observer = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => {
          if (entry.isIntersecting) {
            entry.target.classList.add("is-visible");
            observer.unobserve(entry.target);
          }
        });
      },
      { rootMargin: "0px 0px -10% 0px", threshold: 0.1 }
    );
    revealItems.forEach((el) => observer.observe(el));
  }

  /* ---------- Jaartal in de footer ---------- */
  document.querySelectorAll("[data-year]").forEach((el) => {
    el.textContent = String(new Date().getFullYear());
  });

  /* ---------- Contactformulier ----------
     De server serveert alleen statische bestanden, dus dit formulier opent een
     e-mail met de ingevulde gegevens (mailto). Wil je berichten echt ontvangen
     via een service zoals Formspree of Netlify Forms, vervang dan alleen het
     stukje onder "window.location.href" door een fetch() naar die service. */
  const form = document.getElementById("contact-form");
  if (form) {
    const status = form.querySelector(".form-status");
    const email = form.dataset.email || "";

    function setStatus(message, kind) {
      if (!status) return;
      status.textContent = message;
      status.className = "form-status" + (kind ? " is-" + kind : "");
    }

    form.addEventListener("submit", (event) => {
      event.preventDefault();
      const data = new FormData(form);
      const name = String(data.get("naam") || "").trim();
      const from = String(data.get("email") || "").trim();
      const message = String(data.get("bericht") || "").trim();

      if (!name || !from || !message) {
        setStatus("Vul je naam, je e-mailadres en een bericht in.", "error");
        return;
      }
      if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(from)) {
        setStatus("Dat e-mailadres lijkt niet te kloppen.", "error");
        return;
      }
      if (!email) {
        setStatus("Er is nog geen e-mailadres ingesteld (data-email op het formulier).", "error");
        return;
      }

      const subject = encodeURIComponent("Bericht via de website van " + name);
      const body = encodeURIComponent(message + "\n\n\u2014 " + name + " (" + from + ")");
      window.location.href = "mailto:" + email + "?subject=" + subject + "&body=" + body;
      setStatus("Je e-mailprogramma opent met dit bericht — verstuur het daar.", "success");
      form.reset();
    });
  }
})();
