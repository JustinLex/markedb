import {PatchResponse} from "~/bindings/PatchResponse";
import {toJson} from "tsconfck";

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