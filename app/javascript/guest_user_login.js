function  guestLogin(){
  const guestLogin = document.getElementById("guest-login");
  guestLogin.addEventListener("click", () => {
    const userEmail = document.getElementById("user_email");
    const userPassword = document.getElementById("user_password");
    const loginBtn = document.getElementById("login-btn");
    userEmail.value = "1@1"
    userPassword.value = 111111
    loginBtn.click();
  });
};

window.addEventListener('load', guestLogin);