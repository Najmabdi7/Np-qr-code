# Impression des étiquettes POINTS — mode direct (sans dialogue)

Deux façons d'imprimer sans la fenêtre d'impression de Chrome. Elles sont indépendantes :
on peut faire la première tout de suite, la seconde quand l'informatique est disponible.

Imprimante visée : **Zebra LP 2824 Plus** (USB), 203 dpi, étiquettes 1,5 × 1 in (38,1 × 25,4 mm).

---

## 1. Tout de suite, sans rien installer : raccourci « kiosk-printing »

**Fichier :** `Imprimer-Points.bat`

1. Faire un clic droit sur le `.bat` → *Envoyer vers* → *Bureau* (pour créer un raccourci).
2. **Une seule fois sur le poste :**
   - la Zebra LP 2824 Plus doit être l'**imprimante par défaut** de Windows ;
   - faire une impression normale (bouton IMPRIMER) avec les bons réglages :
     **papier 38,1 × 25,4 mm**, **Marges = Aucune**, **Échelle = 100 %**. Chrome mémorise ces
     réglages pour la suite.
3. Ensuite, on lance la page par ce raccourci : le bouton IMPRIMER envoie l'étiquette
   **directement à l'imprimante**, sans aucun dialogue.

Le raccourci utilise un profil Chrome dédié (`%LocalAppData%\NewPharmaPrint`), donc ça marche
même si une autre fenêtre Chrome est déjà ouverte.

**Limites :** aucune alerte si l'imprimante est éteinte ou vide, et plus de choix de réglages
au moment d'imprimer (tout vient des réglages mémorisés à l'étape 2).

---

## 2. Le vrai mode direct : Zebra Browser Print (ZPL natif)

Avec Browser Print, la page n'envoie plus une **image** au pilote d'impression : elle envoie le
**ZPL**, le langage de l'imprimante. C'est l'imprimante qui dessine elle-même le Data Matrix et
le code-barres.

Ce que ça change concrètement :

- **Data Matrix : module de 0,75 mm** au lieu de 0,39 mm (2× plus gros) → lecture beaucoup plus
  tolérante, surtout si l'impression est un peu pâle ;
- **codes net au point près** : plus de réduction d'image par le navigateur, donc des barres et
  des modules aux largeurs entières ;
- **silencieux et instantané** : aucun dialogue d'impression ;
- les **valeurs encodées sont identiques** à aujourd'hui (vérifié : `5522051`,
  `ABCD1234567890XYZ`, `Étoile-Île`) — rien ne change pour les douchettes.

### Installation (par poste, une seule fois)

1. Installer **Zebra Browser Print** (téléchargement sur le site Zebra, section *Browser Print*
   → l'application démarre ensuite avec Windows, icône dans la zone de notification).
2. **Accepter le certificat local** : ouvrir `https://localhost:9101/ssl_support` dans Chrome
   et accepter l'avertissement. Étape obligatoire, **une fois par navigateur**. Sans elle,
   l'impression directe échoue sans message clair.
3. **Copier le SDK** dans ce dépôt : depuis
   `C:\Program Files\Zebra\BrowserPrint\Documentation\BrowserPrint.js\`
   copier `BrowserPrint-3.1.250.min.js` (et `BrowserPrint-Zebra-*.min.js` s'il existe) à la
   racine du dépôt, à côté d'`index.html`, puis redéployer.
   Si le nom du fichier est différent, compléter la liste `PRINTER.sdkFiles` dans `index.html`.
4. Vérifier : ouvrir la page, sous le bouton IMPRIMER le texte doit afficher
   **« Impression directe : imprimante Zebra (silencieux) »**.

Si ce texte affiche « Impression navigateur », voir le dépannage ci-dessous : la page fonctionne
quand même, exactement comme aujourd'hui.

---

## Dépannage

- **Le texte reste sur « Impression navigateur »**
  Browser Print n'est pas lancé, ou le certificat du point 2 n'a pas été accepté, ou les fichiers
  du SDK ne sont pas à côté de la page. Tester `https://localhost:9101/available` dans Chrome.
- **Le certificat a expiré** (valable 2 ans) : quitter Browser Print (clic droit sur l'icône →
  *Exit*), supprimer `%LocalAppData%\Zebra\BrowserPrint\keystore.jks`, relancer l'application,
  accepter le nouveau certificat, refaire l'étape 2.
- **Rien ne s'imprime en mode direct** : vérifier que l'imprimante est allumée et définie comme
  imprimante par défaut dans Browser Print (`http://localhost:9101/`).
- **Accents en carrés ou en « ? »** : mettre `utf8: false` dans l'objet `PRINTER` en haut du
  script (`index.html`). Les accents sont alors remplacés par leur lettre de base (É → E).
- **Les étiquettes se décalent / l'imprimante avance trop** : mettre `useLabelLength: true`
  dans `PRINTER` (ajoute `^LL203`, donc 1 in par étiquette), ou recalibrer l'imprimante pour ce
  média (bouton *Feed* + `~JC`).
- **Rien ne sort du tout en mode direct (ni code ni texte)** : le Data Matrix ECC 200
  (`dmQuality: 200`) demande un firmware récent. Vérifier la version du firmware de
  l'imprimante ; en attendant, rester en impression navigateur (repli automatique).
- **Codes longs** : ce générateur accepte du texte libre. Un texte très long agrandit le Data
  Matrix (il reste centré mais descend vers la ligne de texte). Pour un code de points standard
  (7 chiffres) aucun souci.

---

## Réglages — objet `PRINTER` en haut du script de `index.html`

| Clé | Valeur | Rôle |
|---|---|---|
| `dpi` | 203 | résolution de la LP 2824 Plus (8 dots/mm) |
| `labelW` / `labelH` | 304 / 203 | étiquette 1,5 × 1 in en dots |
| `dmModule` | 6 | taille d'un module Data Matrix en dots (6 = 0,75 mm) |
| `dmQuality` | 200 | ECC 200 — indispensable pour les douchettes actuelles |
| `useLabelLength` | false | `true` = ajoute `^LL203` (longueur d'étiquette) |
| `utf8` | true | `false` = accents remplacés (imprimante sans UTF-8) |
| `sdkFiles` | liste | noms de fichiers du SDK Zebra cherchés à côté de la page |
| `agentUrls` | liste | adresses locales testées pour détecter Browser Print |

---

## Ce qui n'a pas changé

- Les **valeurs encodées** et la logique métier (codes de points) sont intactes.
- Si Browser Print n'est pas installé, la page utilise le chemin d'impression navigateur, comme
  avant (avec ou sans le raccourci du point 1).
