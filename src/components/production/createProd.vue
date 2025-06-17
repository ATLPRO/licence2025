<script setup>
import { ref, onMounted, watch, computed} from 'vue'

const personnels = ref([])
const articlesFini = ref([])
const articlesFinis=ref('')
const magasin = ref([])
const magasins = ref('')
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
// Chargement des données initiales
onMounted( () => {
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
    reference: c.refArtFils,
    designation: c.desArt,
    intituleU: c.intituleU,
    qteUnitaire: parseFloat(c.qteN),
    pu: parseFloat(c.puN),
    montant: parseFloat(c.qteN) * parseFloat(c.puN),
    qteNecessaire: parseFloat(c.qteN) * parseFloat(production.value.qteAproduire)
    //qteDisponible: c.qteStock || 0 // à adapter si ton API renvoie la qté dispo
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


// Recalcul quand la quantité à produire change
watch(() => production.value.qteAproduire, (qte) => {
  lignes.value.forEach(ligne => {
    ligne.qteNecessaire = ligne.qteUnitaire * qte
  })
})
const coutTotalProduction = computed(() => {
  return lignes.value.reduce((total, ligne) => {
    return total + (ligne.qteUnitaire * ligne.pu)
  }, 0) / production.value.qteAproduire
})
const stockInsuffisant = computed(() => {
  return lignes.value.some(l => l.qteDisponible < l.qteNecessaire)
})

</script>

<template>
  <div class="container mt-4">
    <!-- ENTÊTE -->
    <div class="card mb-4">
      <div class="card-header bg-primary text-white">Informations de production</div>
      <div class="card-body row g-3">
        <div class="col-md-3">
          <label class="form-label">Numéro production *</label>
          <input v-model="production.idprod" class="form-control" required/>
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
        <div class="col-md-4">
          <label class="form-label">Article à produire *</label>
          <select v-model="articlesFinis" class="form-select" required>
            <option disabled value="">-- Sélectionner --</option>
            <option v-for="a in articlesFini" :value="a.idArt" :key="idArt">{{ a.desArt }}</option>
          </select>
        </div>
        <div class="col-md-4">
          <label class="form-label">Magasin *</label>
          <select v-model=" magasins" class="form-select" required>
          <option disabled value="">-- Choisir --</option>
          <option v-for="m in magasin" :value="m.idmag" :key="m.idmag">{{ m.nomMag }}</option>
        </select>
        </div>
        <div class="col-md-4">
          <label class="form-label">Quantité à produire *</label>
          <input type="number" v-model="production.qteAproduire" min="1" class="form-control" required/>
        </div>
      </div>
    </div>

    <!-- CORPS - Matières premières nécessaires -->
    <div class="card">
      <div class="card-header bg-secondary text-white">Matières premières nécessaires</div>
      <div class="card-body">
        <table class="table table-bordered">
          <thead>
            <tr>
              <th>Référence</th>
              <th>Désignation</th>
              <th>Unité</th>
              <th>Qté/unité</th>
              <th>PU</th>
              <th>Montant</th>
              <th>Qté nécessaire</th>
              <th>Qté disponible</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(ligne, i) in lignes" :key="i">
              <td>{{ ligne.reference }}</td>
              <td>{{ ligne.designation }}</td>
              <td>{{ ligne.intituleU }}</td>
              <td>{{ ligne.qteUnitaire }}</td>
              <td>{{ ligne.pu }}</td>
              <td>{{ ligne.montant.toFixed(2) }}</td>
              <td>{{ ligne.qteNecessaire }}</td>
              <td :class="{'text-danger fw-bold': ligne.qteDisponible < ligne.qteNecessaire}">{{ ligne.qteDisponible }}</td>
            </tr>
            <tr v-if="lignes.length === 0">
              <td colspan="7" class="text-center text-muted">Aucune matière première chargée</td>
            </tr>
          </tbody>
        </table>
        <div v-if="stockInsuffisant" class="alert alert-warning mt-3">
          ⚠️ Attention : certaines matières premières n'ont pas assez de stock pour cette production.
        </div>

        <div class="d-flex justify-content-between">
          <h5 class="text-end">Cout total de production : {{ coutTotalProduction.toFixed(2) }} FCFA</h5>
        </div>
        <div class="text-end mt-4">
          <button class="btn btn-primary me-2" @click="enregistrerProduction">Enregistrer</button>
          <button class="btn btn-outline-dark" @click="imprimerProduction">Imprimer</button>
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
