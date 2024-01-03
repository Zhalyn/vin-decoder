import { createElement } from 'lwc';
import VinDecoder from 'c/vinDecoder';
import getAllVehicleInfo from '@salesforce/apex/VinDecoderApi.getAllVehicleInfo';

// Mock the Apex method
jest.mock(
    '@salesforce/apex/VinDecoderApi.getAllVehicleInfo',
    () => ({
        default: jest.fn()
    }),
    { virtual: true }
);

describe('c-vin-decoder', () => {
    afterEach(() => {
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
        jest.clearAllMocks();
    });

    it('calls getAllVehicleInfo when VIN length is 17', () => {
        const element = createElement('c-vin-decoder', {
            is: VinDecoder
        });
        document.body.appendChild(element);

        // Set VIN input value to trigger handleVinChange
        element.vinNumber = '12345678901234567';
        element.handleVinChange({ target: { value: '12345678901234567' } });

        // Ensure getAllVehicleInfo is called
        expect(getAllVehicleInfo).toHaveBeenCalledWith({ vinNumber: '12345678901234567' });
    });

    it('dispatches FlowNavigationNextEvent when handleSubmit is called', () => {
        const element = createElement('c-vin-decoder', {
            is: VinDecoder
        });
        document.body.appendChild(element);

        // Mock available actions
        element.availableActions = ['NEXT'];

        // Call handleSubmit
        element.handleSubmit();

        // Ensure FlowNavigationNextEvent is dispatched
        expect(element.dispatchEvent).toHaveBeenCalled();
    });
});
