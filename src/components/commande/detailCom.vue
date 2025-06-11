<script setup>

import { ref, computed, watch ,onMounted} from 'vue'

// Props : numéro de commande passé par le parent
const props = defineProps({
  numcom: String
})

// État local
const commande = ref(null)
const lignes = ref([])

// Chargement des données
async function chargerDetailCommande(numcom) {
  //console.log("Chargement des détails pour :", numcom)
  try {
    const res = await fetch(
      `http://localhost/apiLicence2025/controller/commande/detailcom.php?host=localhost&dbname=licence2025&username=root&password=`
    ,{
      method:'POST',
       headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ numcom })
    });
    if (!res.ok) throw new Error('Erreur serveur')
    const data = await res.json()
    console.log('Données reçues :', data)
    // On suppose que les champs généraux (numcom, date...) sont les mêmes sur chaque ligne
    if (data.length > 0) {
      const entete = data[0]
      commande.value = {
        numcom: entete.numcom,
        datecom: entete.datecom,
        refcom: entete.refcom,
        nomfour: entete.nomfour,
      }
      lignes.value = data.map(item => ({
        desArt: item.desArt,
        qteC: parseFloat(item.qteC),
        puC: parseFloat(item.puC),
        intituleU: item.intituleU,
      }))
    }
  } catch (err) {
    console.error('Erreur chargement détail commande :', err)
  }
}
onMounted(() => {
  if (props.numcom) {
    console.log("numcom a changé :", props.numcom)
    chargerDetailCommande(props.numcom)
  }
})


// Total ligne et commande
const totalLigne = ligne => ligne.qteC * ligne.puC

const totalCommande = computed(() =>
  lignes.value.reduce((total, ligne) => total + totalLigne(ligne), 0)
)
function imprimer() {
  window.print()
}

</script>

<template>
  <div v-if="commande" class="container mt-4">
    <h4 class="mb-4 text-primary">Détail des achats</h4>

    <div class="row mb-3">
      <div class="col-md-3"><strong>Numéro :</strong> {{ commande.numcom }}</div>
      <div class="col-md-3"><strong>Date :</strong> {{ commande.datecom }}</div>
      <div class="col-md-3"><strong>Référence :</strong> {{ commande.refcom }}</div>
      <div class="col-md-3"><strong>Fournisseur :</strong> {{ commande.nomfour }}</div>
    </div>

    <table class="table table-bordered">
      <thead class="table-light">
        <tr>
          <th>Article</th>
          <th>Quantité</th>
          <th>Grammage</th>
          <th>Prix unitaire</th>
          <th>Total</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="(ligne, index) in lignes" :key="index">
          <td>{{ ligne.desArt }}</td>
          <td>{{ ligne.qteC }}</td>
          <td>{{ ligne.intituleU }}</td>
          <td>{{ ligne.puC }} FCFA</td>
          <td>{{ totalLigne(ligne) }} FCFA</td>
        </tr>
      </tbody>
    </table>

    <div class="text-end">
      <h5>Total de la commande : {{ totalCommande }} FCFA</h5>
    </div>
      <div class="text-end mt-3">
        <button class="btn btn-secondary btn-sm" @click="imprimer">Imprimer</button>
      </div>
      <button class="btn btn-secondary no-print" @click="$emit('fermer')">Fermer</button>

  </div>
  
  <div v-else class="text-center text-muted">
    Chargement en cours ou aucune commande sélectionnée...
  </div>
</template>
<style scoped>
  @media print {
  .no-print {
    display: none !important;
  }
  body {
    background: white;
    margin: 0;
  }
}

</style>
    

