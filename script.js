(function(){
  document.querySelectorAll('.compare-range').forEach(function(input){
    function change(){var frame=input.parentElement.querySelector('[data-comparison]'); frame.style.setProperty('--reveal',input.value+'%');}
    input.addEventListener('input',change);change();
  });
  if(window.matchMedia('(prefers-reduced-motion: reduce)').matches) return;
  var io=new IntersectionObserver(function(entries){entries.forEach(function(e){if(e.isIntersecting){e.target.classList.add('seen');io.unobserve(e.target)}})},{threshold:0.11});
  document.querySelectorAll('.case-tile,.steps article,.featured-case,.section-head,.story-cols>div,.evidence-grid figure,.comparison').forEach(function(x){x.classList.add('reveal');io.observe(x)});
})();

// Mailto handoff only: no web form submission, storage or analytics.
const intakeForm=document.getElementById('lead-form');
if(intakeForm){ intakeForm.addEventListener('submit',e=>{
  e.preventDefault();
  const f=(id)=>document.getElementById(id)?.value.trim()||'';
  const subject='New creative R&D enquiry — '+(f('company')||f('focus'));
  const body=['Name: '+f('contact-name'),'Company / project: '+f('company'),'Type: '+f('focus'),'Stage: '+f('stage'),'What needs to change:','',f('challenge'),'','Budget / scope: '+(f('budget')||'Not shared')].join('\n');
  const emailUrl='mailto:omar.khair70@gmail.com?subject='+encodeURIComponent(subject)+'&body='+encodeURIComponent(body);
  window.location.href=emailUrl;
  const status=document.getElementById('intake-status'); if(status)status.textContent='Your mail application should open. If it does not, email omar.khair70@gmail.com directly.';
});}
