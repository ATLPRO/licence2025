<script setup>
import {
  Chart as ChartJS,
  Title,
  Tooltip,
  Legend,
  LineElement,
  CategoryScale,
  LinearScale,
  PointElement
} from 'chart.js'

import { Line } from 'vue-chartjs'
import { ref, onMounted } from 'vue'

ChartJS.register(CategoryScale, LinearScale, PointElement, LineElement, Title, Tooltip, Legend)

const chartData = ref({
  labels: [],
  datasets: [
    {
      label: 'Stock total',
      data: [],
      borderColor: '#42a5f5',
      backgroundColor: 'rgba(66, 165, 245, 0.2)',
      fill: true,
      tension: 0.4
    }
  ]
})

const chartOptions = {
  responsive: true,
  plugins: {
    legend: { position: 'top' },
    title: { display: true, text: 'Évolution des stocks globaux' }
  },
  scales: {
    y: { beginAtZero: true }
  }
}
const isLoading = ref(true)

onMounted(async () => {
  try {
    const res = await fetch('http://localhost/apiLicence2025/controller/stats/getEvolutionStocks.php?host=localhost&dbname=licence2025&username=root&password=')
    const result = await res.json()

    if (Array.isArray(result.data)) {
      chartData.value.labels = result.data.map(item => item.mois)
      chartData.value.datasets[0].data = result.data.map(item => item.stock_total)
      isLoading.value = false
    } else {
      console.error("Format API inattendu", result)
    }
  } catch (error) {
    console.error("Erreur chargement stocks", error)
  }
})
</script>

<template>
    <p v-if="isLoading">Chargement du graphique...</p>
  <Line :data="chartData" :options="chartOptions" />
</template>
