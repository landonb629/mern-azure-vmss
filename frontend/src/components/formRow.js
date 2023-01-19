import {React} from 'react';

const FormRow = ({type, name, value, clickHandler, disabled}) => { 
    return( 
    <div>
        <label htmlFor={name}>{name}:</label>
        <input type={type} name={name} value={value} onChange={clickHandler} disabled={disabled}></input>
    </div>
    )
}

export default FormRow;