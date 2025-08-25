import { render, screen } from '@testing-library/react'
import Home from '../pages/index'

describe('Homepage', () => {
  it('renders welcome message', () => {
    render(<Home />)
    expect(screen.getByRole('heading', { level: 1 })).toBeInTheDocument()
  })

  it('has working navigation', () => {
    render(<Home />)
    expect(screen.getByRole('navigation')).toBeInTheDocument()
  })
})