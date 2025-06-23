<script setup>
import { ref, onMounted } from 'vue'
import { useRoute } from 'vue-router'

const route = useRoute()

const production = ref([])
const composants = ref([])
// Props : numéro de commande passé par le parent
const props = defineProps({
  idprod: Number
})
const chargerDetailProduction = async () => {
  try {
    const res = await fetch(`http://localhost/apiLicence2025/controller/production/getDetailProduction.php?idprod=${props.idprod}&host=localhost&dbname=licence2025&username=root&password=`)
    const data = await res.json()
    production.value = data.production
    composants.value = data.matieres
  } catch (err) {
    console.error('Erreur lors du chargement du détail :', err)
  }
}

onMounted(() => {
  chargerDetailProduction()
})
</script>

<template>
  <div class="container mt-4">
    <div class="card mb-4">
      <div class="card-header bg-primary text-white">Détail de la production</div>
      <div class="card-body row g-3">
        <div class="col-md-4"><strong>Numéro :</strong> {{ production.numprod }}</div>
        <div class="col-md-4"><strong>Référence :</strong> {{ production.refprod }}</div>
        <div class="col-md-4"><strong>Date :</strong> {{ production.dateprod }}</div>
        <div class="col-md-4"><strong>Personnel :</strong> {{ production.nomPersonnel }}</div>
        <div class="col-md-4"><strong>Article produit :</strong> {{ production.desArt }}</div>
        <div class="col-md-4"><strong>Quantité produite :</strong> {{ production.qteProduite }}</div>
        <div class="col-md-4"><strong>Magasin :</strong> {{ production.nomMagasin }}</div>
        <div class="col-md-4"><strong>Coût total :</strong> {{ production.coutTprod }} FCFA</div>
      </div>
    </div>

    <div class="card">
      <div class="card-header bg-secondary text-white">Matières premières utilisées</div>
      <div class="card-body">
        <table class="table table-bordered">
          <thead>
            <tr>
              <th>Référence</th>
              <th>Désignation</th>
              <th>Unité</th>
              <th>Qté utilisée</th>
              <th>PU</th>
              <th>Montant</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(comp, index) in composants" :key="index">
              <td>{{ comp.refArt }}</td>
              <td>{{ comp.desArt }}</td>
              <td>{{ comp.unite }}</td>
              <td>{{ comp.qteL }}</td>
              <td>{{ comp.puL }}</td>
              <td>{{ (comp.puL * comp.qteL).toFixed(2) }}</td>
            </tr>
            <tr v-if="composants.length === 0">
              <td colspan="6" class="text-center text-muted">Aucune matière première trouvée</td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</template>
