<script setup>
import { ref, computed,watch,onMounted,reactive } from 'vue'

const fournisseur=ref([]);
const uniteA=ref([]);
const magasin=ref([])
const magasins=ref('')
const reference=ref('')
const idarticle=ref('')
const magasinsList = ref([]); 
const magasinDepart = ref('')
const magasinArrivee = ref('')

async function chargerMagasin() {
  try {
    const res = await fetch('http://localhost/apiLicence2025/controller/magasin/getMagasins.php?host=localhost&dbname=licence2025&username=root&password=')
    if (!res.ok) throw new Error("Erreur serveur")
    magasinsList.value = await res.json()
  } catch (err) {
    error.value = "Impossible de charger les magasins"
    console.error(err)
  }
}
//genere le nemero de commande automatiquement
async function genererNumeroCommande() {
  try {
    const res = await fetch('http://localhost/apiLicence2025/controller/commande/genererNumeroCom.php?host=localhost&dbname=licence2025&username=root&password=');
    const data = await res.json();
    commande.numero = data.numcom;
  } catch (err) {
    console.error('Erreur lors de la génération du numéro :', err);
  }
}
onMounted(() => {
  //chargeFournisseur();
  //chargearticle()
  chargerMagasin()
  genererNumeroCommande()
})
//verifie que les magasins choisi soient differents
watch([magasinDepart, magasinArrivee], ([depart, arrivee]) => {
  if (depart && arrivee && depart === arrivee) {
    alert("Le magasin de départ et d’arrivée doivent être différents.")
    magasinArrivee.value = ''
  }
})
//renvoies les articles disponible selon le magasin
const articlesDispo = ref([])

watch(magasinDepart, async (idmag) => {
    console.log("Magasin sélectionné :", idmag)
  if (!idmag) return
  try {
    const res = await fetch(`http://localhost/apiLicence2025/controller/stock/getArticlesByMagasin.php?&host=localhost&dbname=licence2025&username=root&password=`
    ,{
  method:'POST',
       headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ idmag })
    });
  
    if (!res.ok) throw new Error("Erreur serveur")
    articlesDispo.value = await res.json()
  } catch (err) {
    console.error("Erreur lors du chargement des articles du magasin", err)
  }
})



const commande = reactive({
  numero: '',
  date: '',
  fournisseurId: '',
  lignes: [],
})

// Ajouter une ligne vide
const ajouterLigne = () => {
  commande.lignes.push({
   articleId: '',
    quantite: 1,
    prixUnitaire: 0,
    grammage: '',
    idu:''
  })
}

// Supprimer une ligne
const supprimerLigne = (index) => {
  commande.lignes.splice(index, 1)
}

// Mettre à jour le prix unitaire en fonction de l'article sélectionné
function mettreAJourPrix(ligne){
  
   const articleChoisie = articlesDispo.value.find(u => u.idArt == ligne.articleId)
  if (articleChoisie) {
    ligne.quantite = articleChoisie.qteS
    ligne.prixUnitaire = articleChoisie.puA
    ligne.grammage = articleChoisie.intituleU
    ligne.idu=articleChoisie.idU
    ligne.idArt=articleChoisie.idArt
    console.log("idunite",ligne.idu)
    console.log("article",ligne.idArt)
  } else {
    ligne.quantite = 0
    ligne.prixUnitaire = 0
    ligne.grammage = ''
  }
}

// Calcul du total ligne
const totalLigne = (ligne) => ligne.quantite * ligne.prixUnitaire

// Calcul du total de commande
const totalCommande = computed(() =>
  commande.lignes.reduce((total, ligne) => total + totalLigne(ligne), 0)
)
const utilisateur = JSON.parse(localStorage.getItem('utilisateurConnecte')); // le même nom que celui utilisé dans la connexion

console.log("Utilisateur connecté :", utilisateur)

const personnel = ref(utilisateur ? utilisateur.idpers : '');  // idpers
const personnelNom = ref(utilisateur ? utilisateur.nompers : ''); // nom

const envoyerCommande = async () => {
   if (!commande.numero || !commande.date  || commande.lignes.length === 0 ) {
    alert("Veuillez remplir tous les champs obligatoires et ajouter au moins un article.");
    return;
  }
  // Construire le payload
  const payload = {
    numT: commande.numero,
    dateT: commande.date,
    idMagSrc: magasinDepart.value,
    idMagDest: magasinArrivee.value,
    idpers: personnel.value,  
    lignes: commande.lignes.map(ligne => ({
      idArt: ligne.articleId,
      qteT: ligne.quantite,
      puT: ligne.prixUnitaire
      
    }))
  };

  try {
    const res = await fetch('http://localhost/apiLicence2025/controller/transfert/createtransfert.php?host=localhost&dbname=licence2025&username=root&password=', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(payload)
    });
// const text = await res.text();
// console.log('Réponse brute:', text);  
    const result = await res.json();
    console.log('Réponse brute:', result);
    if (!res.ok) throw new Error(result.message || 'Erreur lors de l\'envoi');

    alert('✅ ' + result.message);
    // Optionnel : reset du formulaire
    commande.numero = '';
    commande.date = '';
    commande.fournisseurId = '';
    commande.lignes = [];
    reference.value = '';
    magasins.value = '';
  } catch (err) {
    alert('❌ Erreur : ' + err.message);
    console.error(err);
  }
}

</script>

<template>
  <div class="container mt-4">
    <!-- En-tête -->
    <div class="row mb-3">
      <div class="col-md-4">
        <label class="form-label">Numéro d'achat *</label>
        <input v-model="commande.numero" type="text" class="form-control" required readonly disabled/>
      </div>
      <div class="col-md-4">
        <label class="form-label">Date *</label>
        <input v-model="commande.date" type="date" class="form-control" required />
      </div>
      <div class="col-md-4">
        <label class="form-label">Reference de transfert *</label>
        <input v-model="reference" type="text" class="form-control" required />
      </div>
    </div>
    <div class="row mb-3">
      <div class="col-md-4">
        <label class="form-label">Magasin De depart*</label>
        <select v-model="magasinDepart" class="form-select" required>
          <option disabled value="">-- Choisir --</option>
          <option v-for="m in magasinsList" :key="m.idmag" :value="m.idmag">{{ m.nomMag }}</option>
        </select>
      </div>
      <div class="col-md-4">
        <label class="form-label">Magasin D'arriver*</label>
        <select v-model="magasinArrivee" class="form-select" required>
          <option disabled value="">-- Choisir --</option>
          <option v-for="m in magasinsList" :key="m.idmag" :value="m.idmag">{{ m.nomMag }}</option>
        </select>
      </div>
     <div class="col-md-4">
      <label class="form-label">Commande du:</label>
      <input :value="personnelNom" type="text" class="form-control" readonly />
    </div>

    </div>

    <!-- Corps (lignes de commande) -->
    <h5 class="mt-4 mb-2">Articles à transferer</h5>
    <table class="table table-bordered">
      <thead>
        <tr>
          <th>Article</th>
          <th>Quantité</th>
          <th>Prix unitaire</th>
           <th>Grammage</th>
          <th>Total</th>
          <th>Action</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="(ligne, index) in commande.lignes" :key="index">
          <td>
            <select v-model="ligne.articleId" @change="mettreAJourPrix(ligne)" class="form-select" required>
              <option disabled value="">-- Choisir --</option>
              <option v-for="article in articlesDispo" :key="article.idArt" :value="article.idArt">
                {{ article.desArt }}
              </option>
            </select>
          </td>
          <td><input v-model.number="ligne.quantite" type="number" min="1" class="form-control" required /></td>
          <td><input v-model.number="ligne.prixUnitaire" type="number" min="0" class="form-control"  /></td>
          <td><input v-model="ligne.grammage" type="text" min="0" class="form-control" readonly /></td>
          <td>{{ totalLigne(ligne) }} FCFA</td>
          <td><button class="btn btn-danger btn-sm" @click="supprimerLigne(index)">X</button></td>
        </tr>
      </tbody>
    </table>

    <div class="d-flex justify-content-between">
      <button class="btn btn-outline-primary" @click="ajouterLigne">
        <i class="bi bi-plus-circle"></i> Ajouter un article
      </button>
      <h5 class="text-end">Total Achat : {{ totalCommande }} FCFA</h5>
    </div>

    <div class="mt-4 text-end">
      <button class="btn btn-success" @click="envoyerCommande">Valider le transfert</button>
      <!-- <button class="btn btn-success ms-2">Imprimer</button> -->
    </div>
  </div>
</template>
