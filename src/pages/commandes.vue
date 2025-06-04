<script setup>
import createCom from '@/components/commande/createCom.vue';
import detailCom from '@/components/commande/detailCom.vue';
import UpdateCom from '@/components/commande/updateCom.vue';
import { ref } from 'vue';
  
// État des modals
const showAjout = ref(false)
const showModifier = ref(false)
const shawDetail=ref(false)
// Fonctions modals
const openAjoutModal = () => {
  showAjout.value = true
}

const closeAjoutModal = () => {
  showAjout.value = false
}
//Ouvrir la page de modification avec les elements a modifier
const fourAEditer = ref(null)
function openModifier() {
  //fourAEditer.value = fournisseur
  showModifier.value = true
}

const closeModifierModal = () => {
  showModifier.value = false
  codefour.value = null
}
//ouvrir le detail
function openDetail(){
  shawDetail.value=true
}
const closeDetail = () => {
  shawDetail.value = false
  //codefour.value = null
}
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
          <button @click="openDetail" class="btn btn-secondary btn-sm" >Détail</button>
          <button class="btn btn-secondary btn-sm" @click="openAjoutModal">Nouveau</button>
          <button class="btn btn-secondary btn-sm" @click="openModifier">Modifier</button>
          
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
               <th>Montant total(FCFA)</th>
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
                <button @click="openAjoutModal" class="btn btn-sm text-success border-0 me-1" title="Nouveau">
                  <i class="bi bi-plus-circle"></i>
                </button>
                <button @click="openModifier" class="btn btn-sm text-warning border-0 me-1" title="Modifier">
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

    <!-- Modal d’AJOUT -->
  <div v-if="showAjout" class="modal-backdrop fade show"></div>
  <div v-if="showAjout" class="modal fade show d-block" tabindex="-1">
    <div class="modal-dialog modal-lg modal-dialog-centered">
      <div class="modal-content">
        <div class="modal-header bg-primary text-white">
          <h5 class="modal-title">Ajouter une commande</h5>
          <button class="btn-close" @click="closeAjoutModal" aria-label="Fermer"></button>
        </div>
        <div class="modal-body">
          <createCom @close="closeAjoutModal" />
        </div>
      </div>
    </div>
  </div>
 <!-- Modal de detail -->
 <div v-if="shawDetail" class="modal-backdrop fade show"></div>
  <div v-if="shawDetail" class="modal fade show d-block" tabindex="-1">
    <div class="modal-dialog modal-lg modal-dialog-centered">
      <div class="modal-content">
        <div class="modal-header bg-primary text-white">
          <h5 class="modal-title">Detail de la commande</h5>
          <button class="btn-close" @click="closeDetail" aria-label="Fermer"></button>
        </div>
        <div class="modal-body">
          <detailCom  @close="closeDetail" />
        </div>
      </div>
    </div>
  </div>
 <!-- Modal de MODIFICATION -->
  <div v-if="showModifier" class="modal-backdrop fade show"></div>
  <div v-if="showModifier" class="modal fade show d-block" tabindex="-1">
    <div class="modal-dialog modal-lg modal-dialog-centered">
      <div class="modal-content">
        <div class="modal-header bg-primary text-white">
          <h5 class="modal-title">Modifier une commande</h5>
          <button class="btn-close" @click="closeModifierModal" aria-label="Fermer"></button>
        </div>
        <div class="modal-body">
          <UpdateCom  @close="closeModifierModal" />
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
  