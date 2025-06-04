<script setup>
  import { ref,onMounted,watch,computed } from 'vue'
  import { useRouter } from 'vue-router'
  
 const famille=ref([])// Liste des familles récupérées depuis l’API
  const reference=ref('')
  const designation=ref('')
  const type=ref('')
  const quantiteUnitaire=ref('')
  const prixAchat=ref('')
  const grammage=ref('')
  const prixVente=ref('')
  const stockInitial=ref('')
  const error = ref('')
  const success = ref('')
  const idFam = ref('')  // pour stocker l'ID sélectionné
  
  const props = defineProps({
  article: Object
})
onMounted(async () => {
  await chargerFamilles() // attendre que le tableau soit prêt
})
//charger les intitule de la famille dans le select famille
  async function chargerFamilles() {
  try {
    const res = await fetch('http://localhost/apiLicence2025/controller/famille/readAllfamille.php?host=localhost&dbname=licence2025&username=root&password=')
    if (!res.ok) throw new Error("Erreur serveur")
    famille.value = await res.json()
  } catch (err) {
    error.value = "Impossible de charger les familles d'articles"
    console.error(err)
  }
}

// Charger dès que la reference de l'article change
watch(() => props.article, (a) => {
  if (a) {
    reference.value = a.refArt
    designation.value = a.desArt
    quantiteUnitaire.value = a.QteUArt
    grammage.value = a.grammage
    prixAchat.value = a.pA
    prixVente.value = a.PV
    stockInitial.value = a.stockMin
    type.value = a.typeArt
    idFam.value = a.idFam  // c'est ce qui sélectionne l'option du <select>
  }
}, { immediate: true })

 //pour modifier un article
async function handleSubmit() {
  error.value = ''
  success.value = ''
  if (!reference.value || !designation.value || !quantiteUnitaire.value || !stockInitial.value || !grammage.value || !prixAchat.value  || !type.value ) {
    error.value = "Tous les champs sont requis."
    return
  }
  const payload = {
    refArt:reference.value,
    desArt: designation.value,
    QteUArt: quantiteUnitaire.value,
    grammage: grammage.value,
    pA: prixAchat.value,
    PV:prixVente.value,
    typeArt:type.value,
    stockMin:stockInitial.value,
    idFam:idFamille.value,
  }
  try {
    const res = await fetch('http://localhost/apiLicence2025/controller/article/updatearticle.php?host=localhost&dbname=licence2025&username=root&password=', {

      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(payload),
    })

    const data = await res.json()
    console.log("api",data)
    if (res.ok) {
      success.value = data.message || "Article Modifier avec succès."
      // Petite pause avant redirection
      setTimeout(() => {
        router.push('/articles')
      }, 1500)
    } else {
      error.value = data.message || "Erreur lors de la modification."
    }
  } catch (e) {
    error.value = "Erreur réseau ou serveur indisponible."
    console.error(e)
  }

}
 
  </script>

<template>
    <div class="container py-4">
      <div class="card shadow">
        
        <div class="card-body">
          <form @submit.prevent="handleSubmit">
            <!-- Afficher l'erreur ou le succes selon le cas -->
      <div v-if="error" class="alert alert-danger">{{ error }}</div>
      <div v-if="success" class="alert alert-success">{{ success }}</div>
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
                <input v-model="prixVente" type="number" class="form-control" id="prixVente"  />
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
                <select v-model="idFam" class="form-select" required>
                  <option value="">-- Sélectionner une famille --</option>
                  <option v-for="f in famille" :key="f.idFam" :value="f.idFam">
                     {{ f.intituleFam }}
                  </option>
                 </select>
              </div>
              
              <div class="col-md-4">
                <label for="stockInitial" class="form-label">Stock initial</label>
                <input v-model="stockInitial" type="number" class="form-control" id="stockInitial" required />
     
              </div>
            </div>
  
            <div class="mt-4 d-flex justify-content-between">
              <button type="submit" class="btn btn-success">
                <i class="bi bi-check-circle me-1"></i> Modifier
              </button>
              <button @click="$emit('close')" class="btn btn-secondary">
                <i class="bi bi-x-circle me-1"></i> Annuler
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>
  </template>
  
  
  