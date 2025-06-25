<script setup>
import { reactify } from '@vueuse/core'
import { ref, onMounted, watch, computed,reactive} from 'vue'

const productionEnregistree = ref(false)

const numero = ref('')
const stockable=ref('')
const articlesFini = ref([])
const articlesFinis=ref('')
const magasin = ref([])
const magasins = ref('')
const magasinArrivee=ref('')
const articleSelectionne = ref(null)

const production = ref({
  idprod: '',
  refprod: '',
  dateprod: new Date().toISOString().substring(0, 10),
  idpers: '',
  refArt: '',
  qteAproduire: 1
})
const utilisateur = JSON.parse(localStorage.getItem('utilisateurConnecte')); // le même nom que celui utilisé dans la connexion
const personnel = ref(utilisateur ? utilisateur.idpers : '');  // idpers
const personnelNom = ref(utilisateur ? utilisateur.nompers : ''); // nom

const lignes = ref([]) // lignes du tableau matières premières
//charger les magasins
async function chargerMagasin() {
  try {
    const res = await fetch('http://localhost/apiLicence2025/controller/magasin/getMagasins.php?host=localhost&dbname=licence2025&username=root&password=')
    if (!res.ok) throw new Error("Erreur serveur")
    magasin.value = await res.json()
  } catch (err) {
    error.value = "Impossible de charger les magasins"
    console.error(err)
  }
}
//charger les articles produit fini qui sont nommer
async function chargearticleproduitfini() {
  try {
    const res = await fetch('http://localhost/apiLicence2025/controller/avoir/readAllProduitFini.php?host=localhost&dbname=licence2025&username=root&password=')
    if (!res.ok) throw new Error("Erreur serveur")
    articlesFini.value = await res.json()
  } catch (err) {
    error.value = "Impossible de charger les unites"
    console.error(err)
  }
}
//genere le nemero de production automatiquement
async function genererNumeroProduction() {
  try {
    const res = await fetch('http://localhost/apiLicence2025/controller/production/genererautoNumProd.php?host=localhost&dbname=licence2025&username=root&password=');
    const data = await res.json();
    numero.value = data.numprod;
  } catch (err) {
    console.error('Erreur lors de la génération du numéro :', err);
  }
}
// Chargement des données initiales
onMounted( () => {
  genererNumeroProduction()
  console.log('numero',numero)
  chargearticleproduitfini()
  chargerMagasin()
})

// Lorsqu'on sélectionne un article fini, charger ses composants (matières premières)
watch(() => articlesFinis.value, async (idArt) => {
  if (!idArt) return
  const res = await fetch('http://localhost/apiLicence2025/controller/nommer/getComposantsByIdArt.php?host=localhost&dbname=licence2025&username=root&password=', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ idArt })
  })
  const composants = await res.json()
  lignes.value = composants.map(c => ({
    idArt:c.idArtFils,
    reference: c.refArtFils,
    designation: c.desArt,
    typeArt:c.typeArt,//pour exception des stocks disponibles
   
    intituleU: c.intituleU,
    qteUnitaire: parseFloat(c.qteN),
    pu: parseFloat(c.puN),
    montant: parseFloat(c.qteN) * parseFloat(c.puN),
    qteNecessaire: parseFloat(c.qteN) * parseFloat(production.value.qteAproduire),
    stockable: !(c.typeArt === 'divers' && ['cout machine', 'cout ressources humaines', 'cout autres charges'].includes(c.desArt.toLowerCase())) //pour exception des stocks disponibles
  }))
})
// Lorsqu'on sélectionne un magasin fini, charger ses qte disponible (matières premières)
watch([articlesFinis, magasins], async ([idArt, idmag]) => {
  if (!idArt || !idmag) return

  const res = await fetch('http://localhost/apiLicence2025/controller/stock/getstockDisponible.php?host=localhost&dbname=licence2025&username=root&password=', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ idArt, idmag })
  })

  const stockDisponible = await res.json()

  // Mise à jour des qteDisponible dans le tableau `lignes`
  lignes.value = lignes.value.map(ligne => {
    const stock = stockDisponible.find(s => s.refArtFils === ligne.reference)
    return {
      ...ligne,
      qteDisponible: stock ? parseFloat(stock.qteS) : 0
    }
  })
})


// Recalcul qte necessaire quand la quantité à produire change
watch(() => production.value.qteAproduire, (qte) => {
  lignes.value.forEach(ligne => {
    ligne.qteNecessaire = ligne.qteUnitaire * qte
  })
})
//calcul du cout de production par article
const coutProductionUnitaire = computed(() => {
  return lignes.value.reduce((total, ligne) => {
    return total + (ligne.montant)
  }, 0)
})
// calcul cout total de production pour un nombre d'article
const coutTotalProduction = computed(() => {
  return lignes.value.reduce((total, ligne) => {
    return total + (ligne.qteNecessaire * ligne.pu)
  }, 0)
})
const stockInsuffisant = computed(() => {
  return lignes.value.filter(l => l.stockable && l.qteDisponible < l.qteNecessaire)
})
const enregistrerProduction = async () => {
  const stockCritique = lignes.value.filter(
  l => l.stockable === true && l.qteDisponible < l.qteNecessaire
)

if (
  !articlesFinis.value ||
  !production.value.qteAproduire ||
  !numero.value ||
  !magasins.value ||
  !magasinArrivee.value ||
  stockCritique.length > 0
) {
  alert("Veuillez remplir tous les champs et vérifier les stocks des articles.");
  return;
}


  const payload = {
    numprod: numero.value,
    refprod: production.value.refprod,
    date: production.value.dateprod,
    cout: coutTotalProduction.value,
    idpers: personnel.value,
    idMagSource: magasins.value,
  idMagDest: magasinArrivee.value,
    matieres: lignes.value.map(l => ({
    idArt: l.idArt,
    qteL: l.qteNecessaire,
    puL:l.pu
  })),
  produitFini: {
    idArt: articlesFinis.value,
    qte: production.value.qteAproduire
  }
  }

  try {
    const res = await fetch(`http://localhost/apiLicence2025/controller/production/validerProduction.php?host=localhost&dbname=licence2025&username=root&password=`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json"
      },
      body: JSON.stringify(payload)
    })

    const result = await res.json()

    if (result.success) {
      alert("✅ " + result.message)
      genererNumeroProduction()
      productionEnregistree.value = true;

      //resetForm()
      // reset des champs si besoin
    } else {
      alert("❌ Erreur : " + result.message)
    }

  } catch (err) {
    console.error("Erreur API :", err)
    alert("❌ Une erreur est survenue.")
  }
}
function resetForm() {
  production.value.refprod = '';
  production.value.dateprod = new Date().toISOString().substring(0, 10);
  production.value.qteAproduire = 1;
  articlesFinis.value = '';
  magasins.value = '';
  magasinArrivee.value = '';
  lignes.value = [];
   productionEnregistree.value = false;
}
//impression
const imprimerProduction = async () => {
  if (!productionEnregistree.value) {
    alert("Veuillez d'abord enregistrer la production avant d'imprimer.");
    return;
  }
  const payload = {
    numprod: numero.value,
    refprod: production.value.refprod,
    date: production.value.dateprod,
    cout: coutTotalProduction.value,
    produitFini: {
      idArt: articlesFinis.value,
      qte: production.value.qteAproduire
    },
    matieres: lignes.value.map(l => ({
      idArt: l.idArt,
      designation: l.designation,
      qteL: l.qteNecessaire,
      puL: l.pu
    }))
  }

  try {
    const res = await fetch('http://localhost/apiLicence2025/controller/etats/impressionProduction.php', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(payload)
    })

    const blob = await res.blob()
    const url = URL.createObjectURL(blob)
    window.open(url, '_blank') // Ouvre le PDF dans un nouvel onglet

  } catch (err) {
    console.error("Erreur lors de l'impression :", err)
    alert("Erreur lors de la génération du PDF.")
  }
}

</script>

<template>
  <div class="container mt-4">
    <!-- ENTÊTE -->
    <div class="card mb-4">
      <div class="card-header bg-primary text-white">Informations de production</div>
      <div class="card-body row g-3">
        <div class="col-md-3">
          <label class="form-label">Numéro production *</label>
          <input v-model="numero" class="form-control" required readonly disabled/>
        </div>
        <div class="col-md-3">
          <label class="form-label">Référence production *</label>
          <input v-model="production.refprod" class="form-control" required/>
        </div>
        <div class="col-md-3">
          <label class="form-label">Date *</label>
          <input type="date" v-model="production.dateprod" class="form-control" required/>
        </div>
        <div class="col-md-3">
          <label class="form-label">Personnel</label>
          <input :value="personnelNom" type="text" class="form-control" readonly />
        </div>
        <div class="col-md-3">
          <label class="form-label">Article à produire *</label>
          <select v-model="articlesFinis" class="form-select" required>
            <option disabled value="">-- Sélectionner --</option>
            <option v-for="a in articlesFini" :value="a.idArt" :key="idArt">{{ a.desArt }}</option>
          </select>
        </div>
        <div class="col-md-3">
          <label class="form-label">Magasin M premiere*</label>
          <select v-model=" magasins" class="form-select" required>
          <option disabled value="">-- Choisir --</option>
          <option v-for="m in magasin" :value="m.idmag" :key="m.idmag">{{ m.nomMag }}</option>
        </select>
        </div>
        <div class="col-md-3">
          <label class="form-label">Quantité à produire *</label>
          <input type="number" v-model="production.qteAproduire" min="1" class="form-control" required/>
        </div>
         <div class="col-md-3">
        <label class="form-label">Magasin Production*</label>
        <select v-model="magasinArrivee" class="form-select" required>
          <option disabled value="">-- Choisir --</option>
          <option v-for="m in magasin" :key="m.idmag" :value="m.idmag">{{ m.nomMag }}</option>
        </select>
      </div>
      </div>
    </div>

    <!-- CORPS - Matières premières nécessaires -->
    <div class="card">
      <div class="card-header bg-secondary text-white">Matières premières nécessaires</div>
      <div class="card-body" style="overflow-x: auto;">
        <table class="table table-bordered">
          <thead>
            <tr>
              <th>Référence</th>
              <th>Désignation</th>
              <th>Unité</th>
              <th>Qté/unité</th>
              <th>Qté disponible</th>
              <th>Qté nécessaire</th>
              <th>PU</th>
              <th>Montant/unité</th>
              <th>Montant/QteProduit</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(ligne, i) in lignes" :key="i">
              <td>{{ ligne.reference }}</td>
              <td>{{ ligne.designation }}</td>
              <td>{{ ligne.intituleU }}</td>
              <td>{{ ligne.qteUnitaire }}</td>
              <td :class="{
                'text-danger fw-bold': ligne.stockable && ligne.qteDisponible < ligne.qteNecessaire
              }">
                {{ ligne.stockable ? ligne.qteDisponible : '—' }}
              </td>

               <td>{{ ligne.qteNecessaire }}</td>
              <td>{{ ligne.pu }}</td>
              <td>{{ ligne.montant }}</td>
              <td>{{ (ligne.qteNecessaire*ligne.pu) }}</td>
            </tr>
            <tr v-if="lignes.length === 0">
              <td colspan="9" class="text-center text-muted">Aucune matière première chargée</td>
            </tr>
          </tbody>
        </table>
        <div v-if="stockInsuffisant.length > 0" class="alert alert-warning mt-3">
  ⚠️ Attention : les matières premières suivantes n'ont pas assez de stock :
  <ul>
    <li
      v-for="matiere in stockInsuffisant"
      :key="matiere.reference"
    >
      {{ matiere.designation }} (dispo : {{ matiere.qteDisponible }}, requis : {{ matiere.qteNecessaire }})
    </li>
  </ul>
</div>


        <div class="d-flex justify-content-between">
          <h5 class="text-end">Cout de production unitaire: {{ coutProductionUnitaire }} FCFA</h5>
        </div>
        <div class="d-flex justify-content-between">
          <h5 class="text-end">Cout total de production : {{ coutTotalProduction }} FCFA</h5>
        </div>
        <div class="text-end mt-4">
          <button class="btn btn-primary me-2" @click="enregistrerProduction">Enregistrer</button>
          <button class="btn btn-outline-dark" 
          @click="imprimerProduction"
           :disabled="!productionEnregistree">Imprimer</button>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.table td, .table th {
  vertical-align: middle;
}
</style>
