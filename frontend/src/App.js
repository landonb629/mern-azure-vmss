import { BrowserRouter, Routes, Route, Link } from 'react-router-dom';
import styled from 'styled-components'
import { Register, Home } from './pages/'

function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<Register />} />
        <Route path="/home" element={<Home />} />
      </Routes>
    </BrowserRouter>
  )
}

export default App;
