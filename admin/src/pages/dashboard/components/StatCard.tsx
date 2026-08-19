import type { ReactNode } from 'react'
import { Box, Card, CardContent, Typography } from '@mui/material'

export interface StatCardProps {
  title: string
  value: string | number
  icon: ReactNode
  color?: string
}

export const StatCard = ({ title, value, icon, color = 'primary.main' }: StatCardProps) => {
  return (
    <Card sx={{ borderRadius: 4, height: '100%' }}>
      <CardContent>
        <Box sx={{ display: 'flex', alignItems: 'center', gap: 2 }}>
          <Box
            sx={{
              width: 56,
              height: 56,
              borderRadius: 3,
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
              backgroundColor: color,
              color: '#fff',
            }}
          >
            {icon}
          </Box>
          <Box>
            <Typography variant="h4" fontWeight={700}>
              {value}
            </Typography>
            <Typography variant="body2" color="text.secondary">
              {title}
            </Typography>
          </Box>
        </Box>
      </CardContent>
    </Card>
  )
}
