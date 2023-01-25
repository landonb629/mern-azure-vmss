import { BrowserRouter, Routes, Route} from 'react-router-dom';
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
