

<template>
  <div class="container-fluid py-4">
    <!-- Titre principal -->
    <div class="d-flex justify-content-between align-items-center mb-4">
      <h2 class="text-primary">Tableau de bord</h2>
     
    </div>

    <!-- Cartes statistiques -->
   
  <div class="container py-2">
    
    <div class="row g-2">
      <div class="col-12 col-sm-3 col-lg-3">
        <div class="card text-white bg-primary shadow ">
          <div class=" card-body ">
            <h5 class="card-title ">Articles</h5>
            <p class="card-text fs-3">2</p>
            <i class="bi bi-box-seam fs-1 "></i>
          </div>
        </div>
      </div>
      <div class="col-12 col-sm-3 col-lg-3">
        <div class="card text-white bg-success shadow">
          <div class="card-body">
            <h5 class="card-title">Fournisseurs</h5>
            <p class="card-text fs-3">2</p>
            <i class="bi bi-truck fs-1"></i>
          </div>
        </div>
      </div>
      <div class="col-12 col-sm-3 col-lg-3">
        <div class="card text-white bg-warning shadow">
          <div class="card-body">
            <h5 class="card-title">Commandes</h5>
            <p class="card-text fs-3">2</p>
            <i class="bi bi-cart-check fs-1"></i>
          </div>
        </div>
      </div>
      <div class="col-12 col-sm-3 col-lg-3">
        <div class="card text-white bg-danger shadow">
          <div class="card-body">
            <h5 class="card-title">Magasins</h5>
            <p class="card-text fs-3">2</p>
            <i class="bi bi-building fs-1"></i>
          </div>
        </div>
      </div>
    </div>
  </div>


    <!-- Graphiques -->
    <!-- <div class="row mb-4">
      <div class="col-md-6 mb-3">
        <div class="card p-3 shadow-sm">
          <h5 class="mb-3">Commandes par mois</h5> 
           Graphique à intégrer ici 
          <canvas id="commandeChart"></canvas>
        </div>
      </div>
      <div class="col-md-6">
        <div class="card p-3 shadow-sm">
          <h5 class="mb-3">Top 5 articles</h5>
          Graphique à intégrer ici 
          <canvas id="topArticlesChart"></canvas>
        </div>
      </div>
    </div>
-->
    <!-- Alertes -->
    <div class="card p-3 shadow-sm mb-4">
      <h5 class="mb-3 text-danger">Alertes</h5>
      <ul class="list-group list-group-flush">
        <li class="list-group-item" v-for="alerte in alertes" :key="alerte">⚠️ {{ alerte }}</li>
      </ul>
    </div>

    <!-- Liens rapides -->
    <div class="d-flex flex-wrap gap-2">
      <button class="btn btn-outline-primary"><i class="bi bi-box"></i> Ajouter article</button>
      <button class="btn btn-outline-success"><i class="bi bi-cart-plus"></i> Nouvelle commande</button>
      <button class="btn btn-outline-warning"><i class="bi bi-person-plus"></i> Nouveau fournisseur</button>
    </div>
  </div>
</template>

<script setup>
import { onMounted, ref } from 'vue'

const statCards = [
  { title: 'Articles en stock', value: 125, icon: 'bi bi-box-seam' },
  { title: 'Fournisseurs', value: 18, icon: 'bi bi-truck' },
  { title: 'Magasins', value: 5, icon: 'bi bi-shop' }
]

const alertes = [
  'Article A1 en rupture',
  'Commande C023 en attente',
  'Stock critique pour Article B7'
]

onMounted(() => {
  // Initialisation des graphiques Chart.js à faire ici si besoin
})
</script>

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
