<script setup>
import { ref, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import FamilleArticle from './familleArticle.vue'

const route = useRoute()

const article = ref({})
const matieres = ref([])
const composants = ref([])
// Props : reference de l'article passé par le parent
const props = defineProps({
  refArt: String,
  idArt:Number
})

// Chargement des données
async function chargerInfosArticle() {
  //console.log("Chargement des détails pour :", numcom)
  try {
    const res = await fetch(
      `http://localhost/apiLicence2025/controller/article/detailArticle.php?host=localhost&dbname=licence2025&username=root&password=`
    ,{
      method:'POST',
       headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({refArt:props.refArt })
    });
    if (!res.ok) throw new Error('Erreur serveur')
    const data = await res.json()
    console.log('Données reçues :', data)
    // On suppose que les champs généraux (numcom, date...) sont les mêmes sur chaque ligne
    if (data.length > 0) {
      const entete = data[0]
      article.value = {
        refArt: entete.refArt,
        desArt: entete.desArt,
        typeArt: entete.typeArt,
        intituleFam:entete.intituleFam,
        grammage:entete.grammage,
        stockMin:entete.stockMin,
        idArt:entete.idArt,
      }
       } 
    }catch (err) {
    console.error('Erreur chargement détail article :', err)
  }
}
async function compositionArticle() {
   try {
    const res = await fetch(
      `http://localhost/apiLicence2025/controller/article/compositionArticle.php?host=localhost&dbname=licence2025&username=root&password=`
    ,{
      method:'POST',
       headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ idArt: props.idArt })
    });
    if (!res.ok) throw new Error('Erreur serveur')
    const data = await res.json()
    console.log('Données reçues :', data)
    // On suppose que les champs généraux (numcom, date...) sont les mêmes sur chaque ligne
    composants.value = data.map(c => ({
    reference:  c.refArt,
    designation:c.desArt,
    qte:        c.qteN,
    pu:         c.puN,
    montant:    (c.qteN * c.puN).toFixed(2),
    unite:      c.intituleU
  }))
       
    }catch (err) {
    console.error('Erreur chargement détail article :', err)
  }
}
 onMounted(async () => {
  console.log('Props reçues dans detailArticle:', props)
chargerInfosArticle()
compositionArticle()
})
</script>

<template>
  <div class="container mt-3">
    <!-- En-tête de l'article -->
    <div class="card mb-3">
      <div class="card-header bg-primary text-white">
        Détails de l'article produit fini " {{ article.desArt }} "
      </div>
      <div class="card-body row">
        <div class="col-md-4"><strong>Référence :</strong> {{ article.refArt }}</div>
        <div class="col-md-4"><strong>Désignation :</strong> {{ article.desArt }}</div>
        <div class="col-md-4"><strong>Type :</strong> {{ article.typeArt }}</div>
        <div class="col-md-4"><strong>Famille :</strong> {{ article.intituleFam }}</div>
        <div class="col-md-4"><strong>Grammage :</strong> {{ article.grammage }}</div>
        <div class="col-md-4"><strong>Stock initial :</strong> {{ article.stockMin }}</div>
      </div>
    </div>

    <!-- Corps : composants (matières premières) -->
    <div class="card">
      <div class="card-header bg-secondary text-white">
        Composants du produit fini
      </div>
      <div class="card-body">
        <table class="table table-bordered table-sm">
          <thead>
            <tr>
              <th colspan="6" class="text-center">Matière première</th>
            </tr>
            <tr>
              <th>Reference</th>
              <th>Designation</th>
              <th>Quantité</th>
              <th>PU</th>
              <th>Montant</th>
              <th>Unité</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(comp, i) in composants" :key="i">
              <td>{{ comp.reference }}</td>
              <td>{{ comp.designation }}</td>
              <td>{{ comp.qte }}</td>
              <td>{{ comp.pu }}</td>
              <td>{{ comp.montant }}</td>
              <td>{{ comp.unite }}</td>
            </tr>
            <tr v-if="composants.length === 0">
              <td colspan="6" class="text-center text-muted">Aucun composant défini</td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</template>


