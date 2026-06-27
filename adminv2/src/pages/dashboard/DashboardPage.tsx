import { useEffect, useState, useCallback } from 'react'
import { Box, Container, Grid, CircularProgress, Button } from '@mui/material'
import {
  People as PeopleIcon,
  VpnKey as VpnKeyIcon,
  Groups as GroupsIcon,
  OnlinePrediction as OnlineIcon,
  Refresh as RefreshIcon,
} from '@mui/icons-material'
import { useNotification } from '@gofreego/tsutils'
import { statsService } from '../../services/statsService'
import type { StatsResponse } from '../../apis/proto/openauth/v1/stats'
import { StatCard } from './components/StatCard'
import { PageHeader } from '../../components'

export const DashboardPage = () => {
  const [stats, setStats] = useState<StatsResponse | null>(null)
  const [loading, setLoading] = useState(true)
  const { showNotification } = useNotification()

  const loadStats = useCallback(async () => {
    setLoading(true)
    try {
      const data = await statsService.get()
      setStats(data)
    } catch (error) {
      showNotification('Failed to load statistics', 'error')
      console.error(error)
    } finally {
      setLoading(false)
    }
  }, [showNotification])

  useEffect(() => {
    loadStats()
  }, [loadStats])

  const cards = [
    { title: 'Total Users', value: stats?.totalUsers ?? '0', icon: <PeopleIcon />, color: '#1976d2' },
    { title: 'Active Users', value: stats?.activeUsers ?? '0', icon: <OnlineIcon />, color: '#2e7d32' },
    { title: 'Permissions', value: stats?.totalPermissions ?? '0', icon: <VpnKeyIcon />, color: '#ed6c02' },
    { title: 'Groups', value: stats?.totalGroups ?? '0', icon: <GroupsIcon />, color: '#9c27b0' },
  ]

  return (
    <Container maxWidth="lg">
      <Box sx={{ py: 4 }}>
        <PageHeader
          title="Dashboard"
          subtitle="Overview of your OpenAuth system."
          action={
            <Button
              variant="outlined"
              startIcon={<RefreshIcon />}
              onClick={loadStats}
              disabled={loading}
              sx={{ borderRadius: 2 }}
            >
              Refresh
            </Button>
          }
        />

        {loading ? (
          <Box sx={{ display: 'flex', justifyContent: 'center', py: 6 }}>
            <CircularProgress />
          </Box>
        ) : (
          <Grid container spacing={3}>
            {cards.map((card) => (
              <Grid key={card.title} size={{ xs: 12, sm: 6, md: 3 }}>
                <StatCard title={card.title} value={card.value} icon={card.icon} color={card.color} />
              </Grid>
            ))}
          </Grid>
        )}
      </Box>
    </Container>
  )
}
