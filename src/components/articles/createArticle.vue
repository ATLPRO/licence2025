<script setup>
  import { reactive } from 'vue'
  import { useRouter } from 'vue-router'
  
  const router = useRouter()
  const article = reactive({
    reference: '',
    designation: '',
    quantiteUnitaire: '',
    grammage: '',
    prixAchat: '',
    prixVente: '',
    type: '',
    famille: '',
    stockInitial: '',
  })
  
  const handleSubmit = () => {
    console.log('Article à enregistrer :', article)
    // Tu peux ici appeler une API ou stocker en localStorage selon tes besoins
    router.push('/articles')
  }
  </script>

<template>
    <div class="container py-4">
      <div class="card shadow">
        <!-- <div class="card-header bg-primary text-white">
          <h5 class="mb-0">Ajouter un Article</h5>
        </div> -->
        <div class="card-body">
          <form @submit.prevent="handleSubmit">
            <div class="row g-3">
              <div class="col-md-4">
                <label for="reference" class="form-label">Référence*</label>
                <input v-model="reference" type="text" class="form-control" id="reference" required />
              </div>
              <div class="col-md-4">
                <label for="designation" class="form-label">Désignation*</label>
                <input v-model="designation" type="text" class="form-control" id="designation" required />
              </div>
              <div class="col-md-4">
                <label for="quantiteUnitaire" class="form-label">Quantité Unitaire*</label>
                <input v-model="quantiteUnitaire" type="number" class="form-control" id="quantiteUnitaire" required />
              </div>
              <div class="col-md-4">
                <label for="grammage" class="form-label">Grammage*</label>
                <input v-model="grammage" type="text" class="form-control" id="grammage" required />
              </div>
              <div class="col-md-4">
                <label for="prixAchat" class="form-label">Prix d'achat*</label>
                <input v-model="prixAchat" type="number" class="form-control" id="prixAchat" required />
              </div>
             
              <div class="col-md-4">
                <label for="prixVente" class="form-label">Prix de vente</label>
                <input v-model="prixVente" type="number" class="form-control" id="prixVente" required />
              </div>
              <div class="col-md-4">
                <label for="type" class="form-label">Type*</label>
                <select v-model="type" class="form-select" required>
              <option value="produit fini">Produit fini</option>
              <option value="matiere premiere">Matiere premiere</option>
              <option value="divers">Divers</option>
                </select>  
              </div>
              <div class="col-md-4">
                <label for="famille" class="form-label">Famille*</label>
                <select v-model="famille" class="form-select" required>
              <option value=""></option>
                  </select>
              </div>
              <div class="col-md-4">
                <label for="stockInitial" class="form-label">Stock initial</label>
                <input v-model="stockInitial" type="number" class="form-control" id="stockInitial" required />
     
              </div>
            </div>
  
            <div class="mt-4 d-flex justify-content-between">
              <button type="submit" class="btn btn-success">
                <i class="bi bi-check-circle me-1"></i> Ajouter
              </button>
              <router-link to="/articles" class="btn btn-secondary">
                <i class="bi bi-x-circle me-1"></i> Annuler
              </router-link>
            </div>
          </form>
        </div>
      </div>
    </div>
  </template>
  
  
  