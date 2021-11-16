const devices = new RegExp('Android|webOS|iPhone|iPad|iPod|BlackBerry|BB|PlayBook|IEMobile|Windows Phone|Kindle|Silk|Opera Mini', "i");
  
if (devices.test(navigator.userAgent))
{
	 //События для телефонов
}
else
{
	 //События для ПК
	 
}

//PRELOADER
window.onload = function () {
	document.body.classList.add('loaded_hiding');
	window.setTimeout(function () {
		document.body.classList.add('loaded');
		document.body.classList.remove('loaded_hiding');
	}, 500);
}

/*===== EXPANDER MENU  =====*/ 
const showMenu = (toggleId, navbarId, bodyId)=>{
  const toggle = document.getElementById(toggleId),
  navbar = document.getElementById(navbarId),
  bodypadding = document.getElementById(bodyId)

  if(toggle && navbar){
    toggle.addEventListener('click', ()=>{
      navbar.classList.toggle('expander')

      bodypadding.classList.toggle('body-pd')
    })
  }
}
showMenu('nav-toggle','navbar','body-pd')

/*===== LINK ACTIVE  =====*/ 
const linkColor = document.querySelectorAll('.nav__link')
function colorLink(){
  linkColor.forEach(l=> l.classList.remove('active'))
  this.classList.add('active')
}
linkColor.forEach(l=> l.addEventListener('click', colorLink))


/*===== COLLAPSE MENU  =====*/ 
const linkCollapse = document.getElementsByClassName('collapse__link')
var i

for(i=0;i<linkCollapse.length;i++){
  linkCollapse[i].addEventListener('click', function(){
    const collapseMenu = this.nextElementSibling
    collapseMenu.classList.toggle('showCollapse')

    const rotate = collapseMenu.previousElementSibling
    rotate.classList.toggle('rotate')
  })
}


/*===== MODAL LOGIN  =====*/ 
function modal(e) {
	let modal = document.createElement("div"), block = e.cloneNode(true);

	block.id = "modalBlockLogin";
    block.querySelector("#reg").id = "reg_form";
	block.querySelector("#login").id = "login_form";
	//Rename Login and Reg id
	block.querySelector("#reg_name").id = "modal_reg_name";
	block.querySelector("#reg_email").id = "modal_reg_email";
	block.querySelector("#ref_pass").id = "modal_ref_pass";
	block.querySelector("#login_email").id = "modal_login_email";
	block.querySelector("#login_pass").id = "modal_login_pass";
	block.querySelector("#load_login").id = "modal_load_login";
	block.querySelector("#login_name_comp").id = "modal_login_name_comp";
	block.querySelector("#spinner_pop").id = "modal_spinner_pop";
	
	block.querySelector("#error_reg_name").id = "modal_error_reg_name";
	block.querySelector("#error_reg_email").id = "modal_error_reg_email";
	block.querySelector("#error_ref_pass").id = "modal_error_ref_pass";
	block.querySelector("#error_login_email").id = "modal_error_login_email";
	block.querySelector("#error_login_pass").id = "modal_error_login_pass";
	modal.id = "close_modal";

	Object.assign(modal.style, {
		"z-index": "1000",
		position: "fixed",
		left: "0px",
		top: "0px",
		width: "100%",
		height: "100%",
		backgroundColor: "rgba(0,0,0,.5)"
	});

	Object.assign(block.style, {
		display: "initial",
		opacity: 0,
		position: "absolute",
		left: "50%",
		top: "50%",
		transform: "translate(-50%, calc(-50% + 100px))",
		transition: ".6s opacity, .6s transform"
	});

	modal.appendChild(block);

	document.body.appendChild(modal);

	setTimeout(()=>Object.assign(block.style, {
		opacity: 1,
		transform: "translate(-50%,-50%)"
	}),15);

	modal.addEventListener("click", e => e.target === modal ? document.body.removeChild(modal) : "");
}

/*=============== SHOW MODAL ===============*/
const showModal = (openButton, modalContent) =>{
const openBtn = document.getElementById(openButton),
modalContainer = document.getElementById(modalContent)
	if(openBtn && modalContainer){
		openBtn.addEventListener('click', ()=>{
			modalContainer.classList.add('show-modal')
		})
	}
}
showModal('open-modal','modal-container')

/*=============== CLOSE MODAL ===============*/
const closeBtn = document.querySelectorAll('.close-modal')
function closeModal(){
	const modalContainer = document.getElementById('modal-container')
	modalContainer.classList.remove('show-modal')
}
closeBtn.forEach(c => c.addEventListener('click', closeModal))

/*=============== URL DATA ===============*/
function getUrlVars() {
    var vars = {};
    var parts = window.location.href.replace(/[?&]+([^=&]+)=([^&]*)/gi, function(m,key,value) {
        vars[key] = value;
    });
    return vars;
}

// Пример:   var id = getUrlVars()["id"];

if(Cookies.get('theme_bg') != undefined){
	try {
		document.getElementById('theme').style = Cookies.get('theme_bg');
	  } catch (e) {
		console.log("Тема не применена");
	  }
}