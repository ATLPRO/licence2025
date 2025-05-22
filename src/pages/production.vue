
  
  <script setup>
  const productions = [
    {
      numpro: 'PROD001',
      reference: 'PRO-A-001',
      datepro: '2025-05-01',
      couttotal: 50000
    },
    {
      numpro: 'PROD002',
      reference: 'PRO-B-002',
      datepro: '2025-05-03',
      couttotal: 72000
    }
  ]
  </script>
  

<template>
    <div class="container-fluid py-3">
      <!-- Titre et bouton Actualiser -->
      <div class="d-flex justify-content-between align-items-center mb-3 flex-wrap">
        <h4 class="text-primary">Gestion des productions</h4>
        <router-link to="/acceuil">  <button class="btn btn-danger">
        <i class="bi bi-box-arrow-left me-1"></i> Quitter
      </button>
    </router-link>
      </div>
  
      <!-- Boutons et recherche -->
      <div class="d-flex justify-content-between align-items-center mb-3 flex-wrap gap-2">
        <div class="btn-group">
          <button class="btn btn-secondary btn-sm">Détail</button>
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
              <th>Numéro</th>
              <th style="min-width: 130px;">Référence</th>
              <th style="min-width: 130px;">Date</th>
              <th style="min-width: 130px;">Coût Total</th>
              <th style="min-width: 130px;">Action</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(pro, index) in productions" :key="index">
              <td>{{ pro.numpro }}</td>
              <td>{{ pro.reference }}</td>
              <td>{{ pro.datepro }}</td>
              <td>{{ pro.couttotal }} FCFA</td>
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
  
      <!-- imprimer -->
      <div class="text-end mt-3">
        <button class="btn btn-secondary btn-sm">Imprimer</button>
      </div>
    </div>
  </template>
  <style scoped>
 
  @media (max-width: 768px) {
    .table th, .table td {
      font-size: 0.85rem;
    }
  }
  </style>
  