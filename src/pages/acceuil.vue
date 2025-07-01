<script setup>
import { onMounted, ref } from 'vue'
import createArticle from '@/components/articles/createArticle.vue'
import createCom from '@/components/commande/createCom.vue'
import createProd from '@/components/production/createProd.vue'
import productionChart from '@/components/productionChart.vue'
import productionChartStock from '@/components/productionChartStock.vue'

// État des modals
const showAjout = ref(false)
const showArticle = ref(false)
const showAjoutPro=ref(false)

// Fonctions modals
const openAjoutModal = () => {
  showAjout.value = true
}

const closeAjoutModal = () => {
  showAjout.value = false
}
// Fonctions modals
const openAjoutArticle = () => {
  showArticle.value = true
}

const closeAjoutArticle = () => {
  showArticle.value = false
}
// Fonctions modals
const openAjoutProd = () => {
  showAjoutPro.value = true
}

const closeAjoutProduction = () => {
  showAjoutPro.value = false
}
const stats = ref({
  articles: 0,
  fournisseurs: 0,
  commandes: 0,
  magasins: 0
})

async function chargerStats() {
  const res = await fetch('http://localhost/apiLicence2025/controller/stats/dashboard.php?host=localhost&dbname=licence2025&username=root&password=')
  if (res.ok) {
    stats.value = await res.json()
  }
}
/* const cards = [
  { key: 'articles', label: 'Articles', icon: 'bi bi-box-seam', color: 'bg-primary' },
  { key: 'fournisseurs', label: 'Fournisseurs', icon: 'bi bi-truck', color: 'bg-success' },
  { key: 'commandes', label: 'Achats', icon: 'bi bi-cart-check', color: 'bg-warning' }
] */

//const alertes = ref([])
const alertesMatierePremiere = ref([])
const stocksProduitFini = ref([])

const chargerAlertes = async () => {
  const res = await fetch('http://localhost/apiLicence2025/controller/stats/getAlerteStock.php?host=localhost&dbname=licence2025&username=root&password=')
  if (res.ok) {
   const data = await res.json()
    alertesMatierePremiere.value = data.alertes_matiere_premiere || []
    stocksProduitFini.value = data.stocks_produit_fini || []
  }
}
const dernieresCommandes = ref([])
const chargerDernierCom = async () => {
   try {
    const res = await fetch('http://localhost/apiLicence2025/controller/stats/getDernierCommande.php?host=localhost&dbname=licence2025&username=root&password=')
    const json = await res.json()
    if (json.success) {
      dernieresCommandes.value = json.data
    }
  } catch (err) {
    console.error("Erreur chargement dernières commandes :", err)
  }
}
const dernieresProduction = ref([])
const chargerDernierPro = async () => {
   try {
    const res = await fetch('http://localhost/apiLicence2025/controller/stats/getDernierProduction.php?host=localhost&dbname=licence2025&username=root&password=')
    const json = await res.json()
    if (json.success) {
      dernieresProduction.value = json.data
    }
  } catch (err) {
    console.error("Erreur chargement dernières commandes :", err)
  }
}
onMounted(() => {
  chargerStats()
  chargerAlertes()
  chargerDernierCom()
  chargerDernierPro()
})

</script>

<template>
  <div class="container-fluid py-4">
    <!-- Titre principal -->
    <div class="d-flex justify-content-between align-items-center mb-4">
      <h2 class="text-primary">Tableau de bord</h2>
     
    </div>
    
     <div class="container  mt-1">
        <productionChart />
      </div>
    <!-- Cartes statistiques -->
   
   <div class="container py-2">
    <div class="row g-2">
      <div class="col-12 col-sm-3 col-lg-4" v-for="(valeur, label, index) in cards" :key="index">
        <div :class="`card text-white shadow ${valeur.color}`">
          <div class="card-body">
            <h5 class="card-title">{{ valeur.label }}</h5>
            <p class="card-text fs-3">{{ stats[valeur.key] }}</p>
            <i :class="`fs-1 ${valeur.icon}`"></i>
          </div>
        </div>
      </div>
    </div>
  </div>


    <!-- Alertes -->
<div class="card p-3 shadow-sm mb-4" v-if="alertesMatierePremiere.length || stocksProduitFini.length">
  <h5 class="mb-3 text-danger">Alertes matières premières</h5>
  <ul class="list-group list-group-flush" v-if="alertesMatierePremiere.length">
    <li class="list-group-item" v-for="alerte in alertesMatierePremiere" :key="alerte">
      ⚠️ {{ alerte }}
    </li>
  </ul>

  <h5 class="mb-3 mt-4 text-primary">Stocks produits finis</h5>
  <ul class="list-group list-group-flush" v-if="stocksProduitFini.length">
    <li class="list-group-item" v-for="stock in stocksProduitFini" :key="stock">
      ℹ️ {{ stock }}
    </li>
  </ul>
</div>
<div>
    <h5>Dernières achats fournisseurs</h5>
    <table class="table table-striped">
      <thead>
        <tr>
          <th>Référence</th>
          <th>Date</th>
          <th>Fournisseur</th>
          <th>Montant total</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="cmd in dernieresCommandes" :key="cmd.idcom">
          <td>{{ cmd.refcom }}</td>
          <td>{{ new Date(cmd.datecom).toLocaleDateString() }}</td>
          <td>{{ cmd.fournisseur }}</td>
          <td>{{ cmd.montantTcom }}</td>
        </tr>
      </tbody>
    </table>
  </div>
<div>
    <h5>Dernières productions</h5>
    <table class="table table-striped">
      <thead>
        <tr>
          <th>Numero</th>
          <th>Date</th>
          <th>Personnel</th>
           <th>Article fini</th>
          <th>Qté produite</th>
          <th>Coût total (FCFA)</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="prod in dernieresProduction" :key="prod.idprod">
          <td>{{ prod.numprod }}</td>
          <td>{{ new Date(prod.dateprod).toLocaleDateString() }}</td>
          <td>{{ prod.personnel }}</td>
           <td>{{ prod.article_fini }}</td>
          <td>{{ prod.quantite_produite }}</td>
          <td>{{ prod.coutTprod }}</td>
        </tr>
      </tbody>
    </table>
  </div>
    <!-- Liens rapides -->
    <div class="d-flex flex-wrap gap-2">
      <button class="btn btn-outline-primary " @click="openAjoutArticle"><i class="bi bi-box"></i> Ajouter article</button>
      <button class="btn btn-outline-success" @click="openAjoutModal"><i class="bi bi-cart-plus"  ></i> Nouveau achat</button>
      <button class="btn btn-outline-warning" @click="openAjoutProd"><i class="bi bi-person-plus"></i> Nouvelle production</button>
    </div>
  </div>
   <!-- Modal d’AJOUT -->
  <div v-if="showAjout" class="modal-backdrop fade show"></div>
  <div v-if="showAjout" class="modal fade show d-block" tabindex="-1">
    <div class="modal-dialog modal-lg modal-dialog-centered">
      <div class="modal-content">
        <div class="modal-header bg-primary text-white">
          <h5 class="modal-title">Ajouter un achat</h5>
          <button class="btn-close" @click="closeAjoutModal" aria-label="Fermer"></button>
        </div>
        <div class="modal-body">
          <createCom @close="closeAjoutModal" />
        </div>
      </div>
    </div>
  </div>
  <!-- Modal d’AJOUT -->
  <div v-if="showArticle" class="modal-backdrop fade show"></div>
  <div v-if="showArticle" class="modal fade show d-block" tabindex="-1">
    <div class="modal-dialog modal-lg modal-dialog-centered">
      <div class="modal-content">
        <div class="modal-header bg-primary text-white">
          <h5 class="modal-title">Ajouter un Article</h5>
          <button class="btn-close" @click="closeAjoutArticle" aria-label="Fermer"></button>
        </div>
        <div class="modal-body">
          <createArticle @close="closeAjoutArticle" />
        </div>
      </div>
    </div>
  </div>
   <!-- Modal d’AJOUT -->
  <div v-if="showAjoutPro" class="modal-backdrop fade show"></div>
  <div v-if="showAjoutPro" class="modal fade show d-block" tabindex="-1">
    <div class="modal-dialog modal-lg modal-dialog-centered">
      <div class="modal-content">
        <div class="modal-header bg-primary text-white">
          <h5 class="modal-title">Creer une production</h5>
          <button class="btn-close" @click="closeAjoutProduction" aria-label="Fermer"></button>
        </div>
        <div class="modal-body">
          <createProd @close="closeAjoutProduction" />
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>

.card-body{
  width: 650px;
}
.card-title{
  font-size: 12px;
}
canvas {
  width: 100% !important;
  height: 250px !important;
}
</style>
