import { render, screen } from '@testing-library/react'
import Header from '../../components/Header'

describe('Header Component', () => {
  it('renders the logo', () => {
    render(<Header />)
    expect(screen.getByAltText('Logo')).toBeInTheDocument()
  })

  it('has navigation links', () => {
    render(<Header />)
    expect(screen.getByText('Home')).toBeInTheDocument()
    expect(screen.getByText('About')).toBeInTheDocument()
    expect(screen.getByText('Contact')).toBeInTheDocument()
  })
})