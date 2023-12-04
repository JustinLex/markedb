import {PatchResponse} from "~/bindings/PatchResponse";

interface PatchProps {
  patch: PatchResponse
}

export default function Patch(props: PatchProps) {
  return (
    <div>
      Patch example
      <br />
      {JSON.stringify(props.patch)}
    </div>
  );
}