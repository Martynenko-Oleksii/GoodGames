const loginInputEl = document.querySelector(".login-input");
const emailInputEl = document.querySelector(".email-input");


document.addEventListener("DOMContentLoaded", pageLoaded);

function pageLoaded() {
  const oldLogin = Cookies.get("login");
  const oldEmail = Cookies.get("email");

  loginInputEl.placeholder = oldLogin;
  emailInputEl.placeholder = oldEmail;
}