<script setup>
import { identity } from '@vueuse/core'
import { ref, reactive, computed,watch,onMounted } from 'vue'
import { useRouter } from 'vue-router'

const router = useRouter()
// Recevoir la commande à modifier depuis le parent
const props = defineProps({
  comAEditer: Object
})
onMounted(async () => {
  await chargerFournisseurs()
  await chargerMagasins()
  await chargerArticles()
   chargerNomPersonnel()
   //charger les lignes de commande

   initialiserCommande()
})
const chargerNomPersonnel = () => {
  const utilisateur = JSON.parse(localStorage.getItem('utilisateurConnecte'))
  if (utilisateur) {
    personnelNom.value = utilisateur.nompers
    personnel.value = utilisateur.idpers 
  }
}

const chargerFournisseurs = async () => {
  try {
    const res = await fetch('http://localhost/apiLicence2025/controller/fournisseur/getfournisseur.php?host=localhost&dbname=licence2025&username=root&password=')
    fournisseur.value = await res.json()
  } catch (err) {
    console.error('Erreur chargement fournisseurs:', err)
  }
}
async function chargerArticles() {
  try {
    const res = await fetch('http://localhost/apiLicence2025/controller/avoir/readuniteavoir.php?host=localhost&dbname=licence2025&username=root&password=')
    if (!res.ok) throw new Error("Erreur serveur")
    uniteA.value = await res.json()
  } catch (err) {
    error.value = "Impossible de charger les unites"
    console.error(err)
  }
}
const chargerMagasins = async () => {
  try {
    const res = await fetch('http://localhost/apiLicence2025/controller/magasin/getMagasins.php?host=localhost&dbname=licence2025&username=root&password=')
    magasin.value = await res.json()
  } catch (err) {
    console.error('Erreur chargement magasins:', err)
  }
}

const commande = reactive({
  idcom: null,
  numero: '',
  date: '',
  reference: '',
  fournisseurId: '',
  idmag: '',
  lignes: []
})

const fournisseur = ref([])
const magasin = ref([])
const uniteA=ref([]);
const personnelNom = ref('')
const personnel = ref('')


const initialiserCommande = () => {
  const val = props.comAEditer
  //console.log("val.desArt =",val.desArt); 
   if (!val) return
  if (fournisseur.value.length && magasin.value.length) {
    commande.idcom = val.idcom
    commande.numero = val.numcom
    commande.date = val.datecom
    commande.reference = val.refcom
     // Trouver le fournisseur dans la liste par le nom
    const f = fournisseur.value.find(fr => fr.nomfour === val.nomfour)
    commande.fournisseurId = f ? f.idfour : ''

    // Pareil pour magasin
    const m = magasin.value.find(mg => mg.nomMag === val.nomMag)
    commande.idmag = m ? m.idmag : ''

    commande.lignes = Array.isArray(val.lignes)
  ? val.lignes.map(l => {
      // Si articleId est déjà présent (ex: venant du backend), on le garde
      if (l.articleId) return l

      // Sinon, retrouver l'article via la désignation
      const article = uniteA.value.find(a => a.desArt === l.desArt)
      return {
        articleId: article ? article.idArt : '', // On lie par l’ID
        quantite: l.quantite,
        prixUnitaire: l.prixUnitaire,
        uniteId: l.uniteId
      }
    })
  : []

    //commande.lignes = Array.isArray(val.lignes) ? [...val.lignes] : []
  }
  else {
    // Retenter après un court délai si nécessaire
    setTimeout(initialiserCommande, 100)
  }
}

 onMounted(() => {
  /* console.log("Commande reçue :", props.comAEditer)
  console.log("Lignes :", props.comAEditer.lignes) */
}) 
const ajouterLigne = () => {
  commande.lignes.push({ 
    articleId: '', 
    quantite: 1, 
    prixUnitaire: 0 ,
    grammage,
    idu:''
  })
}

const supprimerLigne = (index) => {
  commande.lignes.splice(index, 1)
}

const totalLigne = (ligne) => ligne.quantite * ligne.prixUnitaire

const totalCommande = computed(() =>
  commande.lignes.reduce((total, ligne) => total + totalLigne(ligne), 0)
)


// Mise à jour automatique du prix unitaire selon l'article sélectionné
const updatePrix = (ligne) => {
  const article = uniteA.value.find(a => a.idArt === ligne.articleId)
  if (article) {
      ligne.quantite = article.QteU
    ligne.prixUnitaire = article.PuU
    ligne.uniteId = article.intituleU
    ligne.idu=article.idU
    ligne.idArt=article.idArt
  }
  console.log("idu",ligne.idu)
}

 const enregistrer =async () => {
    if (!commande.numero || !commande.date || !commande.fournisseurId || commande.lignes.length === 0 ) {
    alert("Veuillez remplir tous les champs obligatoires et ajouter au moins un article.");
    return;
  }
  // Construire le payload
  const payload = {
    idcom:commande.idcom,
    numcom: commande.numero,
    refcom: commande.reference,
    datecom: commande.date,
    montantTcom: totalCommande.value,
    idpers: personnel.value,     // à remplir dynamiquement selon l'utilisateur connecté
    idfour: commande.fournisseurId,
    idmag: commande.idmag,
    lignes: commande.lignes.map(ligne => ({
      idArt: ligne.articleId,
      idU: ligne.idu,
      qteC: ligne.quantite,
      puC: ligne.prixUnitaire
      
    }))

  };
    
  try {
    const res = await fetch('http://localhost/apiLicence2025/controller/commande/updateCommande.php?host=localhost&dbname=licence2025&username=root&password=', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(payload)
    });
// const text = await res.text();
// console.log('Réponse brute:', text);  
    const result = await res.json();

    if (!res.ok) throw new Error(result.message || 'Erreur lors de l\'envoi');

    alert('✅ ' + result.message);
    // Optionnel : reset du formulaire
    commande.numero = '';
    commande.date = '';
    commande.fournisseurId = '';
    commande.lignes = [];
    commande.reference = '';
    commande.idmag = '';
  } catch (err) {
    alert('❌ Erreur : ' + err.message);
    console.error(err);
  }
} 
</script>

<template>
  <div  class="container mt-4">
    <h4 class="text-primary mb-4">Modifier l'achat</h4>

    <!-- En-tête -->
    <div class="row g-3 mb-3">
      <div class="col-md-4">
        <label class="form-label">Numéro</label>
        <input v-model="commande.numero" type="text" class="form-control" disabled />
      </div>
      <div class="col-md-4">
        <label class="form-label">Date *</label>
        <input v-model="commande.date" type="date" class="form-control" required />
      </div>
      <div class="col-md-4">
        <label class="form-label">Fournisseur *</label>
        <select v-model="commande.fournisseurId" class="form-select" required>
          <option disabled value="">-- Choisir un fournisseur --</option>
          <option v-for="f in fournisseur" :key="f.idfour" :value="f.idfour">{{ f.nomfour }}</option>
        </select>
      </div>
    </div>
    <div class="row mb-3">
      <div class="col-md-4">
        <label class="form-label">Reference de commande *</label>
        <input v-model="commande.reference" type="text" class="form-control" required />
      </div>
      <div class="col-md-4">
        <label class="form-label">Magasin *</label>
        <select v-model="commande.idmag" class="form-select" required>
          <option disabled value="">-- Choisir --</option>
          <option v-for="m in magasin" :key="m.idmag" :value="m.idmag">{{ m.nomMag }}</option>
        </select>
         <!-- <p>Valeur actuelle magasin : {{ commande.idmag }}</p>
<p>Valeurs possibles : {{ magasin.map(f => f.idmag).join(', ') }}</p> -->
      </div>
     <div class="col-md-4">
      <label class="form-label">Commande du:</label>
      <input :value="personnelNom" type="text" class="form-control" readonly />
    </div>
    </div>

    <!-- Corps -->
    <h5 class="mt-4">Lignes de commande</h5>
    <table class="table table-bordered align-middle">
      <thead class="table-light">
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
            <select v-model="ligne.articleId" @change="updatePrix(ligne)" class="form-select">
              <option value="">-- Choisir un article --</option>
              <option v-for="a in uniteA" :key="a.idArt" :value="a.idArt">
                {{ a.desArt }}
              </option>
            </select>
          </td>
          <td>
            <input v-model.number="ligne.quantite" type="number" min="1" class="form-control" />
          </td>
          <td>
            <input v-model.number="ligne.prixUnitaire" type="number" min="0" class="form-control" />
          </td>
           <td>
            <input v-model="ligne.uniteId" type="text" min="0" class="form-control" readonly />
          </td>
          <td>{{ totalLigne(ligne) }} FCFA</td>
          <td>
            <button class="btn btn-sm btn-danger" @click="supprimerLigne(index)">
              <i class="bi bi-trash"></i>
            </button>
          </td>
        </tr>
      </tbody>
    </table>

    <button class="btn btn-outline-primary mb-3" @click="ajouterLigne">
      <i class="bi bi-plus-circle"></i> Ajouter une ligne
    </button>

    <!-- Total -->
    <div class="text-end mt-4">
      <h5>Total général : {{ totalCommande }} FCFA</h5>
      <button class="btn btn-success me-2" @click="enregistrer">
        <i class="bi bi-save"></i> Enregistrer
      </button>
      <button class="btn btn-secondary " @click="$emit('close')">Fermer</button>
    </div>
  </div>
</template>
