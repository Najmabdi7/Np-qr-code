@echo off
rem ===================================================================
rem  NewPharma - generateur POINTS - impression SANS dialogue
rem  Ouvre Chrome (ou Edge) avec --kiosk-printing : le bouton
rem  IMPRIMER part directement sur l'imprimante par defaut.
rem
rem  A utiliser : creez un raccourci sur le Bureau vers ce fichier.
rem  (clic droit sur le fichier > Envoyer vers > Bureau)
rem
rem  Prerequis (une seule fois sur le poste) :
rem   - la Zebra LP 2824 Plus doit etre l'imprimante PAR DEFAUT
rem   - faire une impression normale une fois pour memoriser les
rem     reglages : papier 38,1 x 25,4 mm, marges = Aucune, echelle = 100%%
rem ===================================================================

set "URL=https://nkh-code.github.io/Np-qr-code/"
set "BROWSER="

if exist "%ProgramFiles%\Google\Chrome\Application\chrome.exe" set "BROWSER=%ProgramFiles%\Google\Chrome\Application\chrome.exe"
if not defined BROWSER if exist "%ProgramFiles(x86)%\Google\Chrome\Application\chrome.exe" set "BROWSER=%ProgramFiles(x86)%\Google\Chrome\Application\chrome.exe"
if not defined BROWSER if exist "%LocalAppData%\Google\Chrome\Application\chrome.exe" set "BROWSER=%LocalAppData%\Google\Chrome\Application\chrome.exe"
if not defined BROWSER if exist "%ProgramFiles%\Microsoft\Edge\Application\msedge.exe" set "BROWSER=%ProgramFiles%\Microsoft\Edge\Application\msedge.exe"
if not defined BROWSER if exist "%ProgramFiles(x86)%\Microsoft\Edge\Application\msedge.exe" set "BROWSER=%ProgramFiles(x86)%\Microsoft\Edge\Application\msedge.exe"

if not defined BROWSER (
  echo Chrome ou Edge n'a pas ete trouve sur ce poste.
  echo Installez Google Chrome puis relancez ce raccourci.
  pause
  exit /b 1
)

rem Profil dedie : l'option fonctionne meme si une autre fenetre Chrome est deja ouverte.
start "" "%BROWSER%" --kiosk-printing --no-first-run --no-default-browser-check --user-data-dir="%LocalAppData%\NewPharmaPrint" "%URL%"
