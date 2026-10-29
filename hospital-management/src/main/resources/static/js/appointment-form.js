// Booking form: shows the times the chosen doctor already has taken on the chosen day.
(() => {
  const form = document.getElementById("appointment-form");
  if (!form) return;

  const doctor = form.elements.doctorId;
  const date = form.elements.appointmentDate;
  const time = form.elements.appointmentTime;
  const hint = document.getElementById("booked-hint");
  let booked = [];

  function showHint() {
    if (!booked.length) {
      hint.hidden = true;
      return;
    }
    const taken = time.value && booked.includes(time.value.slice(0, 5));
    hint.hidden = false;
    hint.textContent = (taken ? "That time is already taken. " : "") + "Already booked for this doctor on this day: " + booked.join(", ") + ".";
  }

  async function loadBooked() {
    booked = [];
    if (!doctor.value || !date.value) {
      showHint();
      return;
    }
    try {
      const res = await fetch(`${form.dataset.bookedUrl}?doctorId=${encodeURIComponent(doctor.value)}&date=${encodeURIComponent(date.value)}`);
      if (res.ok) booked = await res.json();
    } catch (err) {
      booked = [];
    }
    showHint();
  }

  doctor.addEventListener("change", loadBooked);
  date.addEventListener("change", loadBooked);
  time.addEventListener("input", showHint);
  loadBooked();
})();
