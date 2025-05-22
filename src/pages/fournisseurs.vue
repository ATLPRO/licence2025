<script setup>
import { ref, onMounted } from 'vue'
import createFour from '@/components/fournisseur/createFour.vue';
import updateFour from '@/components/fournisseur/updateFour.vue';

// État des modals
const showAjout = ref(false)
const showModifier = ref(false)

// Code du fournisseur à modifier
const codefour = ref(null)

// Fonctions modals
const openAjoutModal = () => {
  showAjout.value = true
}

const closeAjoutModal = () => {
  showAjout.value = false
}

const openModifierModal = (code) => {
  codefour.value = code
  showModifier.value = true
}

const closeModifierModal = () => {
  showModifier.value = false
  codefour.value = null
}
const fournisseur = ref([])
const error = ref('')
//afficher les fours
onMounted(async () => {
  try {
    const res = await fetch('http://localhost/apiLicence2025/controller/fournisseur/getfournisseur.php?host=localhost&dbname=licence2025&username=root&password=')
    if (!res.ok) throw new Error("Erreur serveur")
    fournisseur.value = await res.json()
  } catch (err) {
    error.value = "Impossible de charger les fournisseurs"
    console.error(err)
  }
})
  //supprimer le four
async function deleteFour(codefour) {
  if (!confirm("Confirmer la suppression du fournisseur ?")) return;
  try {
    const res = await fetch(`http://localhost/apiLicence2025/controller/fournisseur/deletefournisseur.php?host=localhost&dbname=licence2025&username=root&password=`, {
      method: 'DELETE',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ codefour })
    });
    const result = await res.json();
    if (result.success) {
      fournisseur.value = fournisseur.value.filter(f => f.codefour !== codefour);
      alert(result.message);
    } else {
      alert(result.message);
    }
  } catch (err) {
    console.error(err);
    alert("Erreur de suppression.");
  }
}
  </script>

<template>
    <div class="container-fluid py-3">
      <!-- Titre et bouton Actualiser -->
      <div class="d-flex justify-content-between align-items-center mb-3 flex-wrap">
        <h4 class="text-primary">Gestion des fournisseurs</h4>
        
      <!-- Quitter -->
      <router-link to="/acceuil">  <button class="btn btn-danger">
        <i class="bi bi-box-arrow-left me-1"></i> Quitter
      </button>
    </router-link>
      </div>
  
      <!-- Boutons et recherche -->
      <div class="d-flex justify-content-between align-items-center mb-3 flex-wrap gap-2">
        <div class="btn-group">
          <button class="btn btn-secondary btn-sm" @click="openAjoutModal">Nouveau</button>
          <!-- <button class="btn btn-secondary btn-sm" data-bs-toggle="modal" data-bs-target="#modalModifier">Modifier</button>
          <button class="btn btn-secondary btn-sm">Supprimer</button> -->
        </div>
        <div class="input-group" style="max-width: 200px;">
          <input type="text" class="form-control form-control-sm" placeholder="Rechercher...">
          <button class="btn btn-outline-secondary btn-sm"><i class="bi bi-search"></i></button>
        </div>
      </div>
  
      <!-- Tableau -->
      <div class="table-responsive">
        <div v-if="error" class="alert alert-danger">{{ error }}</div>
        <table class="table table-hover table-bordered align-middle">
          <thead class="table-primary text-center">
            <tr>
              <th>Code</th>
              <th style="min-width: 100px;">Nom</th>
              <th style="min-width: 100px;">Prénom</th>
              <th style="min-width: 100px;">Tél 1</th>
              <th style="min-width: 100px;">Tél 2</th>
              <th style="min-width: 100px;">Adresse</th>
              <th style="min-width: 100px;">CA</th>
              <th style="min-width: 100px;">Solde initial</th>
              <th style="min-width: 100px;">Solde final</th>
              <th style="min-width: 130px;">Action</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(fournisseur, index) in fournisseur" :key="index">
              <td>{{ fournisseur.codefour }}</td>
              <td>{{ fournisseur.nomfour }}</td>
              <td>{{ fournisseur.prenomfour }}</td>
              <td>{{ fournisseur.tel1four }}</td>
              <td>{{ fournisseur.tel2four }}</td>
              <td>{{ fournisseur.adressefour }}</td>
              <td>{{ fournisseur.cafour }} FCFA</td>
              <td>{{ fournisseur.soldefour }} FCFA</td>
              <td>{{ fournisseur.soldeinitfour }} FCFA</td>
              <td class="text-center">
                <button @click="openAjoutModal" class="btn btn-sm text-success border-0 me-1" title="Nouveau">
                  <i class="bi bi-plus-circle"></i>
                </button>
                <button @click="openModifierModal(codefour)" class="btn btn-sm text-warning border-0 me-1" title="Modifier">
                  <i class="bi bi-pencil-square"></i>
                </button>
                <button @click="deleteFour(codefour)" class="btn btn-sm text-danger border-0" title="Supprimer">
                  <i class="bi bi-trash"></i>
                </button>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
  
    </div>
  
  <!-- Modal d’AJOUT -->
  <div v-if="showAjout" class="modal-backdrop fade show"></div>
  <div v-if="showAjout" class="modal fade show d-block" tabindex="-1">
    <div class="modal-dialog modal-lg modal-dialog-centered">
      <div class="modal-content">
        <div class="modal-header bg-primary text-white">
          <h5 class="modal-title">Ajouter un fournisseur</h5>
          <button class="btn-close" @click="closeAjoutModal" aria-label="Fermer"></button>
        </div>
        <div class="modal-body">
          <createFour @close="closeAjoutModal" />
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
          <h5 class="modal-title">Modifier un fournisseur</h5>
          <button class="btn-close" @click="closeModifierModal" aria-label="Fermer"></button>
        </div>
        <div class="modal-body">
          <updateFour :codefour="codefour" @close="closeModifierModal" />
        </div>
      </div>
    </div>
  </div>
  </template>
  
  <style scoped>
  thead,tbody{
    font-size: 12px;
  }
  @media (max-width: 768px) {
    .table th, .table td {
      font-size: 0.85rem;
    }
  }
  </style>
  