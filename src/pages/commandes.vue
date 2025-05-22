<script setup>
import createCom from '@/components/commande/createCom.vue';
import detailCom from '@/components/commande/detailCom.vue';
import UpdateCom from '@/components/commande/updateCom.vue';
  const commandes = [
    {
      numcommande: 'CMD001',
      nomfour: 'Kouadio & Fils',
      reference: 'REF-A-001',
      datecom: '2025-05-01'
    },
    {
      numcommande: 'CMD002',
      nomfour: 'AgroTech CI',
      reference: 'REF-B-002',
      datecom: '2025-05-02'
    }
  ]
  </script>

<template>
    <div class="container-fluid py-3">
      <!-- Titre et bouton Actualiser -->
      <div class="d-flex justify-content-between align-items-center mb-3 flex-wrap">
        <h4 class="text-primary">Gestion des commandes</h4>
        <router-link to="/acceuil">  <button class="btn btn-danger">
        <i class="bi bi-box-arrow-left me-1"></i> Quitter
      </button>
    </router-link>
      </div>
  
      <!-- Boutons et recherche -->
      <div class="d-flex justify-content-between align-items-center mb-3 flex-wrap gap-2">
        <div class="btn-group">
          <button class="btn btn-secondary btn-sm"  data-bs-toggle="modal" data-bs-target="#modalDetail">Détail</button>
          <button class="btn btn-secondary btn-sm" data-bs-toggle="modal" data-bs-target="#modalCommande">Nouveau</button>
          <button class="btn btn-secondary btn-sm" data-bs-toggle="modal" data-bs-target="#modalUpdate">Modifier</button>
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
              <th>Num Commande</th>
              <th>Nom Fournisseur</th>
              <th style="min-width: 100px;">Référence</th>
              <th>Date</th>
              <th style="min-width: 130px;">Action</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(commande, index) in commandes" :key="index">
              <td>{{ commande.numcommande }}</td>
              <td>{{ commande.nomfour }}</td>
              <td>{{ commande.reference }}</td>
              <td>{{ commande.datecom }}</td>
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

    <!-- Modal de creation -->
<div class="modal fade" id="modalCommande" tabindex="-1" aria-labelledby="modalAjoutLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header bg-primary text-white ">
        <h5 class="modal-title" id="modalAjoutLabel">Nouvelle commande</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Fermer"></button>
      </div>
      <div class="modal-body">
       <createCom/>
      </div>
    </div>
  </div>
</div>
 <!-- Modal de detail -->
 <div class="modal fade" id="modalDetail" tabindex="-1" aria-labelledby="modalAjoutLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header bg-primary text-white ">
        <h5 class="modal-title" id="modalAjoutLabel">Detail de la commande</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Fermer"></button>
      </div>
      <div class="modal-body">
       <detailCom/>
      </div>
    </div>
  </div>
</div>
<!-- Modal de Update -->
<div class="modal fade" id="modalUpdate" tabindex="-1" aria-labelledby="modalAjoutLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header bg-primary text-white ">
        <h5 class="modal-title" id="modalAjoutLabel">Modifier une commande</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Fermer"></button>
      </div>
      <div class="modal-body">
       <UpdateCom/>
      </div>
    </div>
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
  