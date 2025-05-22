<script setup>
import { ref, computed } from 'vue'

// Simulation d'une commande (remplace ça par une vraie récupération API plus tard)
const commande = ref({
  numero: 'CMD-001',
  date: '2025-05-07',
  fournisseur: {
    id: 1,
    nom: 'Fournisseur A',
  },
  lignes: [
    { article: 'Article 1', quantite: 3, prixUnitaire: 1000 },
    { article: 'Article 2', quantite: 2, prixUnitaire: 2500 },
  ],
})

const totalLigne = (ligne) => ligne.quantite * ligne.prixUnitaire

const totalCommande = computed(() =>
  commande.value.lignes.reduce((total, ligne) => total + totalLigne(ligne), 0)
)
</script>

<template>
  <div class="container mt-4">
    <h4 class="mb-4 text-primary">Détail de la commande</h4>

    <div class="row mb-3">
      <div class="col-md-4"><strong>Numéro :</strong> {{ commande.numero }}</div>
      <div class="col-md-4"><strong>Date :</strong> {{ commande.date }}</div>
      <div class="col-md-4"><strong>Fournisseur :</strong> {{ commande.fournisseur.nom }}</div>
    </div>

    <table class="table table-bordered">
      <thead class="table-light">
        <tr>
          <th>Article</th>
          <th>Quantité</th>
          <th>Prix unitaire</th>
          <th>Total</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="(ligne, index) in commande.lignes" :key="index">
          <td>{{ ligne.article }}</td>
          <td>{{ ligne.quantite }}</td>
          <td>{{ ligne.prixUnitaire }} FCFA</td>
          <td>{{ totalLigne(ligne) }} FCFA</td>
        </tr>
      </tbody>
    </table>

    <div class="text-end">
      <h5>Total de la commande : {{ totalCommande }} FCFA</h5>
    </div>
  </div>
</template>
