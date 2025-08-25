import { render, screen } from '@testing-library/react'
import Home from '../pages/index'

describe('Home Page', () => {
  it('renders welcome message', () => {
    render(<Home />)
    expect(screen.getByRole('heading', { name: /welcome/i })).toBeInTheDocument()
  })

  it('renders hero section', () => {
    render(<Home />)
    expect(screen.getByText(/developer/i)).toBeInTheDocument()
  })
})