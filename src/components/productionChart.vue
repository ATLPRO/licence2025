<script setup>
import {
  Chart as ChartJS,
  Title,
  Tooltip,
  Legend,
  BarElement,
  CategoryScale,
  LinearScale
} from 'chart.js'

import { Bar } from 'vue-chartjs'
import { ref, onMounted } from 'vue'

ChartJS.register(CategoryScale, LinearScale, BarElement, Title, Tooltip, Legend)

const chartData = ref({
  labels: [],
  datasets: [
    {
      label: 'Productions / mois',
      backgroundColor: '#42a5f5',
      data: [],
      yAxisID: 'y'
    },
    {
      label: 'Coût total (FCFA)',
      backgroundColor: '#66bb6a',
      data: [],
      yAxisID: 'y1'
    }
  ]
})

const chartOptions = {
  responsive: true,
  interaction: {
    mode: 'index',
    intersect: false
  },
  plugins: {
    legend: { position: 'top' },
    title: {
      display: true,
      text: 'Productions mensuelles et Coût total'
    }
  },
  scales: {
    y: {
      type: 'linear',
      position: 'left',
      title: {
        display: true,
        text: 'Nombre de productions'
      },
      beginAtZero: true
    },
    y1: {
      type: 'linear',
      position: 'right',
      grid: {
        drawOnChartArea: false
      },
      title: {
        display: true,
        text: 'Coût total (FCFA)'
      },
      beginAtZero: true
    }
  }
}

const isLoading = ref(true)

onMounted(async () => {
  try {
    const res = await fetch('http://localhost/apiLicence2025/controller/stats/getStatsProductionMensuelle.php?host=localhost&dbname=licence2025&username=root&password=')
    const result = await res.json()
    console.log("Résultat API =", result)

    if (Array.isArray(result.data)) {
      chartData.value.labels = result.data.map(r => `M${r.mois}`)
      chartData.value.datasets[0].data = result.data.map(r => r.nb_productions)
      chartData.value.datasets[1].data = result.data.map(r => r.total_cout)
      isLoading.value = false
    } else {
      console.error("Format inattendu", result)
    }
  } catch (err) {
    console.error("Erreur lors du fetch", err)
  }
})
</script>

<template>
  <div >
    <p v-if="isLoading">Chargement du graphique...</p>
    <Bar v-else :data="chartData" :options="chartOptions"   />
  </div>
</template>
<style scoped>
    canvas {
  max-width: 600px;   /* Largeur max souhaitée */
  max-height: 200px;  /* Hauteur max souhaitée */
  width: 100%;        /* Pour que ça reste responsive */
  height: auto;
  margin: 0 auto;     /* Centrer horizontalement */
  display: block;
}

</style>
