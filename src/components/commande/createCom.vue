<script setup>
import { ref, reactive, computed } from 'vue'

const fournisseurs = [
  { id: 1, nom: 'Fournisseur A' },
  { id: 2, nom: 'Fournisseur B' },
]

const articlesDisponibles = [
  { id: 1, nom: 'Article 1', prix: 1000 },
  { id: 2, nom: 'Article 2', prix: 2000 },
]

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
  })
}

// Supprimer une ligne
const supprimerLigne = (index) => {
  commande.lignes.splice(index, 1)
}

// Mettre à jour le prix unitaire en fonction de l'article sélectionné
const mettreAJourPrix = (ligne) => {
  const article = articlesDisponibles.find(a => a.id == ligne.articleId)
  ligne.prixUnitaire = article ? article.prix : 0
}

// Calcul du total ligne
const totalLigne = (ligne) => ligne.quantite * ligne.prixUnitaire

// Calcul du total de commande
const totalCommande = computed(() =>
  commande.lignes.reduce((total, ligne) => total + totalLigne(ligne), 0)
)

const envoyerCommande = () => {
  console.log('Commande envoyée :', commande)
  alert('Commande enregistrée avec succès !')
}
</script>

<template>
  <div class="container mt-4">
    <h4 class="mb-4 text-primary">Nouvelle commande</h4>

    <!-- En-tête -->
    <div class="row mb-3">
      <div class="col-md-4">
        <label class="form-label">Numéro de commande</label>
        <input v-model="commande.numero" type="text" class="form-control" required />
      </div>
      <div class="col-md-4">
        <label class="form-label">Date</label>
        <input v-model="commande.date" type="date" class="form-control" required />
      </div>
      <div class="col-md-4">
        <label class="form-label">Fournisseur</label>
        <select v-model="commande.fournisseurId" class="form-select" required>
          <option disabled value="">-- Choisir --</option>
          <option v-for="f in fournisseurs" :key="f.id" :value="f.id">{{ f.nom }}</option>
        </select>
      </div>
    </div>

    <!-- Corps (lignes de commande) -->
    <h5 class="mt-4 mb-2">Articles commandés</h5>
    <table class="table table-bordered">
      <thead>
        <tr>
          <th>Article</th>
          <th>Quantité</th>
          <th>Prix unitaire</th>
          <th>Total</th>
          <th>Action</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="(ligne, index) in commande.lignes" :key="index">
          <td>
            <select v-model="ligne.articleId" @change="mettreAJourPrix(ligne)" class="form-select" required>
              <option disabled value="">-- Choisir --</option>
              <option v-for="article in articlesDisponibles" :key="article.id" :value="article.id">
                {{ article.nom }}
              </option>
            </select>
          </td>
          <td><input v-model.number="ligne.quantite" type="number" min="1" class="form-control" required /></td>
          <td><input v-model.number="ligne.prixUnitaire" type="number" min="0" class="form-control" readonly /></td>
          <td>{{ totalLigne(ligne) }} FCFA</td>
          <td><button class="btn btn-danger btn-sm" @click="supprimerLigne(index)">X</button></td>
        </tr>
      </tbody>
    </table>

    <div class="d-flex justify-content-between">
      <button class="btn btn-outline-primary" @click="ajouterLigne">
        <i class="bi bi-plus-circle"></i> Ajouter un article
      </button>
      <h5 class="text-end">Total commande : {{ totalCommande }} FCFA</h5>
    </div>

    <div class="mt-4 text-end">
      <button class="btn btn-success" @click="envoyerCommande">Valider la commande</button>
    </div>
  </div>
</template>
