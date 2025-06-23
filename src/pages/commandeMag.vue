<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import nouveauTransfert from '@/components/commandeMag/nouveauTransfert.vue'


const stocksParMagasin = ref([])
const router = useRouter()
const showAjout = ref(false)
// Fonctions modals
const allerVersTransfert = () => {
  showAjout.value = true
}

const closeAjoutModal = () => {
  showAjout.value = false
}
async function chargerStocks() {
  const res = await fetch('http://localhost/apiLicence2025/controller/magasin/getStocksParMagasin.php?host=localhost&dbname=licence2025&username=root&password=')
  stocksParMagasin.value = await res.json()
}

/* function allerVersTransfert() {
    router.push({ name: 'Transfert' }) // Adapté selon ton routing
} */

onMounted(() => {
  chargerStocks()
})
</script>

<template>
  <div class="container mt-4">
    <div class="d-flex justify-content-between align-items-center mb-3">
      <h4>Stocks par magasin</h4>
      <button class="btn btn-primary" @click="allerVersTransfert">
        <i class="bi bi-arrow-left-right me-1"></i> Nouveau transfert
      </button>
    </div>

    <div v-for="magasin in stocksParMagasin" :key="magasin.idmag" class="mb-4">
      <div class="card shadow-sm">
        <div class="card-header bg-primary text-white d-flex justify-content-between">
          <strong>{{ magasin.nomMag }}</strong>
          <small>Emplacement : {{ magasin.adresseMag }}</small>
        </div>
        <div class="card-body p-0">
          <table class="table table-bordered table-hover table-sm mb-0">
            <thead class="table-primary">
              <tr>
                <th>Référence</th>
                <th>Désignation</th>
                <th>Quantité</th>
                <th>Unité</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="article in magasin.articles" :key="article.idArt">
                <td>{{ article.refArt }}</td>
                <td>{{ article.desArt }}</td>
                <td>{{ article.qteS }}</td>
                <td>{{ article.intituleU }}</td>
              </tr>
              <tr v-if="magasin.articles.length === 0">
                <td colspan="4" class="text-center text-muted">Aucun stock</td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </div>
     <!-- Modal d’AJOUT -->
  <div v-if="showAjout" class="modal-backdrop fade show"></div>
  <div v-if="showAjout" class="modal fade show d-block" tabindex="-1">
    <div class="modal-dialog modal-lg modal-dialog-centered">
      <div class="modal-content">
        <div class="modal-header bg-primary text-white">
          <h5 class="modal-title">Ajouter un transfert</h5>
          <button class="btn-close" @click="closeAjoutModal" aria-label="Fermer"></button>
        </div>
        <div class="modal-body">
          <nouveauTransfert @close="closeAjoutModal" />
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
table {
  font-size: 0.9rem;
}
</style>
