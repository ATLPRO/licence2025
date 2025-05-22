<template>
    <div class="container-fluid py-3">
      <!-- Titre et bouton Actualiser -->
      <div class="d-flex justify-content-between align-items-center mb-3 flex-wrap">
        <h4 class="text-primary">Gestion du personnel</h4>
        <!-- Quitter -->
        <router-link to="/acceuil">  <button class="btn btn-danger">
        <i class="bi bi-box-arrow-left me-1"></i> Quitter
      </button>
    </router-link>
      </div>
  
      <!-- Boutons et recherche -->
      <div class="d-flex justify-content-between align-items-center mb-3 flex-wrap gap-2">
        <div class="btn-group">
          <button class="btn btn-secondary btn-sm">Nouveau</button>
          <button class="btn btn-secondary btn-sm">Modifier</button>
          <button class="btn btn-secondary btn-sm">Supprimer</button>
        </div>
        <div class="input-group" style="max-width: 200px;">
          <input type="text" class="form-control form-control-sm" placeholder="Rechercher...">
          <button class="btn btn-outline-secondary btn-sm"><i class="bi bi-search"></i></button>
        </div>
      </div>
  
      <!-- Tableau -->
      <div class="table-responsive">
        <table class="table table-hover table-bordered align-middle">
          <thead class="table-primary text-center">
            <tr>
              <th>Matricule</th>
              <th>Nom</th>
              <th>Prénom</th>
              <th>Poste</th>
              <th>Service</th>
              <th>Téléphone</th>
              <th>Adresse</th>
              <!-- <th>Date Embauche</th> -->
              <th style="min-width: 100px;">Salaire</th>
              <th style="min-width: 130px;">Action</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(personnel, index) in personnels" :key="index">
              <td>{{ personnel.matricule }}</td>
              <td>{{ personnel.nom }}</td>
              <td>{{ personnel.prenom }}</td>
              <td>{{ personnel.poste }}</td>
              <td>{{ personnel.telephone }}</td>
              <td>{{ personnel.adresse }}</td>
              <td>{{ personnel.dateEmbauche }}</td>
              <td>{{ personnel.salaire }} FCFA</td>
              <td class="text-center">
                <button class="btn btn-sm text-success border-0 me-1" title="Nouveau">
                  <i class="bi bi-plus-circle"></i>
                </button>
                <button class="btn btn-sm text-warning border-0 me-1" title="Modifier">
                  <i class="bi bi-pencil-square"></i>
                </button>
                <button class="btn btn-sm text-danger border-0" title="Supprimer">
                  <i class="bi bi-trash"></i>
                </button>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
  
    </div>
  </template>
  
  <script setup>
  const personnels = [
    {
      matricule: 'EMP001',
      nom: 'Kouadio',
      prenom: 'Jean',
      poste: 'Magasinier',
      telephone: '0700000000',
      adresse: 'Abidjan',
      dateEmbauche: '2023-01-10',
      salaire: 250000
    },
    {
      matricule: 'EMP002',
      nom: 'Traoré',
      prenom: 'Awa',
      poste: 'Comptable',
      telephone: '0711111111',
      adresse: 'Bouaké',
      dateEmbauche: '2022-06-15',
      salaire: 300000
    }
  ]
  </script>
  
  <style scoped>
  @media (max-width: 768px) {
    .table th, .table td {
      font-size: 0.85rem;
    }
  }
  </style>
  